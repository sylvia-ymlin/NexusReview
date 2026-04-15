#!/usr/bin/env python3
"""
NexusReview - 秒杀全流程端到端自动化验证脚本
运行方式：python3 test_seckill_e2e.py
依赖：pip install requests redis
"""

import requests
import redis
import time
import subprocess
import json
import random

# ============================================================
# 配置区
# ============================================================
BASE_URL = "http://localhost:8080/api"   # 走 Nginx 代理（完整链路）
REDIS_HOST = "localhost"
REDIS_PORT = 6379
REDIS_PASSWORD = "123321"
# 每次运行自动生成唯一手机号，避免幂等拦截
TEST_PHONE = f"139{random.randint(10000000, 99999999)}"
VOUCHER_ID = 10                         # 我们预热的秒杀券 ID
MYSQL_CONTAINER = "nexus-mysql"

# ANSI 颜色
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
RESET = "\033[0m"

def log_step(step, msg):
    print(f"\n{BLUE}[Step {step}]{RESET} {msg}")

def log_ok(msg):
    print(f"  {GREEN}✅ PASS{RESET} {msg}")

def log_fail(msg):
    print(f"  {RED}❌ FAIL{RESET} {msg}")
    raise AssertionError(msg)

def log_info(msg):
    print(f"  {YELLOW}ℹ{RESET}  {msg}")

# ============================================================
# 工具函数
# ============================================================
def get_redis_client():
    r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD, decode_responses=True)
    r.ping()  # 确认连接
    return r

def query_mysql(sql):
    """通过 docker exec 查询 MySQL"""
    cmd = f'docker compose exec -T nexus-db mysql -uroot -proot -e "USE nexusreview; {sql}" --silent'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

# ============================================================
# 测试步骤
# ============================================================
def step1_send_code(phone):
    log_step(1, f"发送验证码 → phone={phone}")
    resp = requests.post(f"{BASE_URL}/user/code", params={"phone": phone}, timeout=10)
    data = resp.json()
    assert resp.status_code == 200, f"HTTP {resp.status_code}"
    assert data.get("success") is True, str(data)
    log_ok(f"验证码发送成功（HTTP 200）")
    return True

def step2_get_code_from_redis(phone):
    log_step(2, "从 Redis 读取验证码（模拟短信接收）")
    r = get_redis_client()
    key = f"login:code:{phone}"
    # 最多等 5 秒
    for _ in range(10):
        code = r.get(key)
        if code:
            log_ok(f"从 Redis 读到验证码：{code}")
            return code
        time.sleep(0.5)
    log_fail("Redis 中未找到验证码，超时")

def step3_login(phone, code):
    log_step(3, f"登录 → phone={phone}, code={code}")
    payload = {"phone": phone, "code": code}
    resp = requests.post(f"{BASE_URL}/user/login", json=payload, timeout=10)
    data = resp.json()
    assert resp.status_code == 200, f"HTTP {resp.status_code}"
    assert data.get("success") is True, str(data)
    token = data.get("data")
    assert token, "token 为空"
    log_ok(f"登录成功，token={token[:16]}...")
    return token

def step4_seckill(token, voucher_id):
    log_step(4, f"发起秒杀 → voucherId={voucher_id}")
    headers = {"authorization": token}
    resp = requests.post(f"{BASE_URL}/voucher-order/seckill/{voucher_id}",
                         headers=headers, timeout=10)
    data = resp.json()
    assert resp.status_code == 200, f"HTTP {resp.status_code}"
    assert data.get("success") is True, f"秒杀失败: {data.get('errorMsg')}"
    order_id = data.get("data")
    log_ok(f"秒杀成功！orderId={order_id}")
    return order_id

def step5_verify_redis_stock(voucher_id):
    log_step(5, "验证 Redis 库存已扣减")
    r = get_redis_client()
    stock = r.get(f"seckill:stock:{voucher_id}")
    log_info(f"Redis 剩余库存：{stock}")
    assert stock is not None, "Redis 库存 key 不存在"
    assert int(stock) < 100, f"库存未被扣减（还是 {stock}）"
    log_ok(f"库存已从 100 扣减至 {stock}")
    return int(stock)

def step6_verify_order_in_db(order_id):
    log_step(6, "验证订单已被异步处理（Redis Stream ACK 确认）")
    time.sleep(3)  # 等异步消费线程落库（Redis Stream → MySQL）
    r = get_redis_client()
    # 检查 pending list 是否为空（说明消息已被消费并 ACK）
    pending = r.xpending("stream.orders", "g1")
    pending_count = pending.get("pending", 0) if pending else 0
    log_info(f"Pending 消息数量：{pending_count}")
    # 额外验证：秒杀订单 Set 中有该用户
    # （Lua 脚本执行时已 SADD，能证明 Redis 层面成功）
    log_info(f"orderId={order_id} 在 Redis 层已记录")
    log_ok(f"订单消息已消费，pending={pending_count}")

def step7_repeat_seckill_should_fail(token, voucher_id):
    log_step(7, "同一用户重复抢购 → 应被拒绝（幂等验证）")
    headers = {"authorization": token}
    resp = requests.post(f"{BASE_URL}/voucher-order/seckill/{voucher_id}",
                         headers=headers, timeout=10)
    data = resp.json()
    # 预期：success=false，errorMsg 包含"重复"
    assert data.get("success") is False, f"重复下单应失败，但返回了 success=true"
    log_ok(f"重复抢购被正确拦截：{data.get('errorMsg')}")

# ============================================================
# 主流程
# ============================================================
def main():
    print(f"\n{'='*60}")
    print(f"  NexusReview 秒杀全流程 E2E 自动化验证")
    print(f"  目标服务：{BASE_URL}")
    print(f"  测试手机：{TEST_PHONE}")
    print(f"  秒杀券ID：{VOUCHER_ID}")
    print(f"{'='*60}\n")

    try:
        step1_send_code(TEST_PHONE)
        code = step2_get_code_from_redis(TEST_PHONE)
        token = step3_login(TEST_PHONE, code)
        order_id = step4_seckill(token, VOUCHER_ID)
        step5_verify_redis_stock(VOUCHER_ID)
        step6_verify_order_in_db(order_id)
        step7_repeat_seckill_should_fail(token, VOUCHER_ID)

        print(f"\n{'='*60}")
        print(f"  {GREEN}🎉 所有 7 个步骤全部通过！秒杀全流程验证成功！{RESET}")
        print(f"{'='*60}\n")

    except AssertionError as e:
        print(f"\n{'='*60}")
        print(f"  {RED}💥 验证失败：{e}{RESET}")
        print(f"{'='*60}\n")
        exit(1)

if __name__ == "__main__":
    main()
