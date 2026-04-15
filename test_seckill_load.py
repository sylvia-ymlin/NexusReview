#!/usr/bin/env python3
"""
秒杀高并发压测脚本
目标：验证 Redis Lua 脚本原子性，确保在高并发下不发生超卖
场景：50 个用户同时抢购库存仅 10 张的券
预期：恰好 10 笔成功，40 笔失败（库存不足）
"""

import requests
import redis
import threading
import time
import random
from concurrent.futures import ThreadPoolExecutor, as_completed

# ============================================================
# 配置
# ============================================================
BASE_URL = "http://localhost:8080/api"
REDIS_HOST = "localhost"
REDIS_PORT = 6379
REDIS_PASSWORD = "123321"

STOCK = 10           # 预热库存（故意设小）
CONCURRENT = 50      # 并发用户数
VOUCHER_ID = 10      # 秒杀券 ID

GREEN = "\033[92m"; RED = "\033[91m"; YELLOW = "\033[93m"; BLUE = "\033[94m"; RESET = "\033[0m"

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD, decode_responses=True)

# ============================================================
# 步骤 1：预热库存到指定值
# ============================================================
def preheat_stock():
    print(f"\n{BLUE}[准备] 重置秒杀库存 → {STOCK} 张{RESET}")
    r.set(f"seckill:stock:{VOUCHER_ID}", STOCK)
    # 清空上轮的订单记录（让同一批手机号可以重新抢）
    r.delete(f"seckill:order:{VOUCHER_ID}")
    actual = r.get(f"seckill:stock:{VOUCHER_ID}")
    print(f"  ✅ Redis 库存已设为：{actual}")

# ============================================================
# 步骤 2：为每个虚拟用户获取 token
# ============================================================
def get_token(phone):
    try:
        requests.post(f"{BASE_URL}/user/code", params={"phone": phone}, timeout=10)
        time.sleep(0.3)
        code_resp = requests.get(f"http://localhost:8081/support/get-code",
                                  params={"phone": phone}, timeout=5)
        code = code_resp.json().get("data", {}).get("code")
        if not code:
            return None
        login_resp = requests.post(f"{BASE_URL}/user/login",
                                    json={"phone": phone, "code": code}, timeout=10)
        return login_resp.json().get("data")
    except Exception as e:
        return None

# ============================================================
# 步骤 3：单个用户发起秒杀
# ============================================================
def seckill_worker(token, user_idx):
    headers = {"authorization": token}
    try:
        resp = requests.post(f"{BASE_URL}/voucher-order/seckill/{VOUCHER_ID}",
                             headers=headers, timeout=10)
        data = resp.json()
        return {
            "user": user_idx,
            "success": data.get("success"),
            "order_id": data.get("data"),
            "error": data.get("errorMsg"),
        }
    except Exception as e:
        return {"user": user_idx, "success": False, "error": str(e)}

# ============================================================
# 主流程
# ============================================================
def main():
    print(f"\n{'='*64}")
    print(f"  ⚡ 秒杀高并发压测")
    print(f"  并发用户数：{CONCURRENT}  |  库存：{STOCK}  |  目标：防超卖")
    print(f"{'='*64}")

    # 1. 重置库存
    preheat_stock()

    # 2. 提前登录获取所有 token（串行，避免登录本身成为瓶颈）
    print(f"\n{BLUE}[准备] 正在为 {CONCURRENT} 个虚拟用户登录...{RESET}")
    tokens = []
    phones = [f"170{random.randint(10000000, 99999999)}" for _ in range(CONCURRENT)]
    
    with ThreadPoolExecutor(max_workers=20) as executor:
        futures = {executor.submit(get_token, phone): i for i, phone in enumerate(phones)}
        for future in as_completed(futures):
            token = future.result()
            if token:
                tokens.append((token, futures[future]))
    
    print(f"  ✅ 成功登录 {len(tokens)} 个用户")
    if len(tokens) < CONCURRENT * 0.8:
        print(f"  {YELLOW}⚠ 登录成功率较低，继续执行...{RESET}")

    # 3. 倒计时 + 同时发起秒杀（模拟抢购瞬间）
    print(f"\n{BLUE}[开始] 3 秒后同时释放 {len(tokens)} 个并发请求...{RESET}")
    for i in range(3, 0, -1):
        print(f"  {i}...")
        time.sleep(1)
    
    start_time = time.time()
    results = []
    barrier = threading.Barrier(len(tokens))  # 同步屏障，确保同时发起

    def controlled_seckill(token, user_idx):
        barrier.wait()  # 所有线程在这里等待，然后同时冲出
        return seckill_worker(token, user_idx)

    with ThreadPoolExecutor(max_workers=len(tokens)) as executor:
        futures = [executor.submit(controlled_seckill, tok, idx) for tok, idx in tokens]
        for future in as_completed(futures):
            results.append(future.result())
    
    elapsed = time.time() - start_time

    # 4. 统计结果
    successes = [r for r in results if r.get("success")]
    failures  = [r for r in results if not r.get("success")]
    stock_empty = [r for r in failures if "库存不足" in str(r.get("error", ""))]
    repeat_deny = [r for r in failures if "重复" in str(r.get("error", ""))]

    # 5. 验证 Redis 最终库存
    final_stock = int(r.get(f"seckill:stock:{VOUCHER_ID}") or 0)

    print(f"\n{'='*64}")
    print(f"  📊 压测结果汇总（耗时 {elapsed:.2f}s）")
    print(f"{'='*64}")
    print(f"  总请求数：  {len(results)}")
    print(f"  {GREEN}成功下单：  {len(successes)}{RESET}")
    print(f"  {RED}库存不足：  {len(stock_empty)}{RESET}")
    print(f"  {YELLOW}重复下单拦截：{len(repeat_deny)}{RESET}")
    print(f"  其他失败：  {len(failures) - len(stock_empty) - len(repeat_deny)}")
    print(f"\n  Redis 最终库存：{final_stock}")
    print(f"{'='*64}")

    # 6. 关键断言：超卖验证
    print(f"\n{'='*64}")
    print(f"  🔍 防超卖验证")
    print(f"{'='*64}")
    
    oversell = len(successes) > STOCK
    if oversell:
        print(f"  {RED}❌ 发生超卖！成功 {len(successes)} 笔 > 库存 {STOCK} 张{RESET}")
    else:
        print(f"  {GREEN}✅ 防超卖验证通过！成功 {len(successes)} 笔 ≤ 库存 {STOCK} 张{RESET}")

    stock_correct = final_stock >= 0
    if stock_correct:
        print(f"  {GREEN}✅ Redis 库存非负（{final_stock}），未出现负库存{RESET}")
    else:
        print(f"  {RED}❌ Redis 库存为负（{final_stock}）！出现超售{RESET}")

    print(f"{'='*64}\n")

if __name__ == "__main__":
    main()
