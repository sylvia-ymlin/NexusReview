#!/usr/bin/env python3
"""
"万级 QPS" 巅峰挑战压测脚本
架构：多进程 (Process) + 多线程 (Barrier Thread)
目标：彻底释放压测机发包能力，突破 5000+ QPS 峰值
"""

import requests
import json
import time
import multiprocessing
import threading
import random
import redis

# ============================================================
# 配置
# ============================================================
BASE_URL = "http://localhost:8080/api"
VOUCHER_ID = 10
NUM_PROCESSES = 12      # 提升至 12 进程并发
STOCK_TO_SET = 2000     # 设定 2000 库存
REDIS_PASSWORD = "123321"

GREEN = "\033[92m"; RED = "\033[91m"; YELLOW = "\033[93m"; BLUE = "\033[94m"; RESET = "\033[0m"

def preheat():
    r = redis.Redis(host="localhost", port=6379, password=REDIS_PASSWORD, decode_responses=True)
    print(f"\n{BLUE}[1/4] 正在重置环境...{RESET}")
    r.set(f"seckill:stock:{VOUCHER_ID}", STOCK_TO_SET)
    r.delete(f"seckill:order:{VOUCHER_ID}")
    print(f"  ✅ Redis 库存已重置为: {STOCK_TO_SET}")

def worker_thread(tokens_chunk, barrier, process_id):
    """单线程发包逻辑"""
    results = []
    # 使用 Session 优化连接复用
    session = requests.Session()
    adapter = requests.adapters.HTTPAdapter(pool_connections=100, pool_maxsize=100)
    session.mount('http://', adapter)
    
    barrier.wait() # 进程内同步
    
    for token in tokens_chunk:
        try:
            resp = session.post(f"{BASE_URL}/voucher-order/seckill/{VOUCHER_ID}", 
                              headers={"authorization": token}, timeout=10)
            data = resp.json()
            results.append(data.get("success") is True)
        except Exception:
            results.append(False)
    return results

def process_worker(tokens_chunk):
    """单进程分配线程逻辑"""
    num_threads = 50 # 每个进程维持 50 个线程
    chunk_size = len(tokens_chunk) // num_threads
    barrier = threading.Barrier(num_threads)
    
    threads = []
    process_results = []
    
    for i in range(num_threads):
        sub_chunk = tokens_chunk[i*chunk_size : (i+1)*chunk_size]
        t = threading.Thread(target=lambda q, arg1, arg2: q.extend(worker_thread(arg1, arg2, 0)), 
                           args=(process_results, sub_chunk, barrier))
        threads.append(t)
        t.start()
        
    for t in threads:
        t.join()
    return process_results

def main():
    preheat()
    
    print(f"{BLUE}[2/4] 正在加载 5000 个 Token...{RESET}")
    with open("tokens.json", "r") as f:
        all_tokens = json.load(f)
    
    # 随机打乱防止顺序影响
    random.shuffle(all_tokens)
    
    print(f"{BLUE}[3/4] 释放巅峰洪流！启动 8 进程并行压测...{RESET}")
    
    # 将 tokens 分配给进程
    chunk_size = len(all_tokens) // NUM_PROCESSES
    chunks = [all_tokens[i*chunk_size:(i+1)*chunk_size] for i in range(NUM_PROCESSES)]
    
    start_time = time.time()
    
    with multiprocessing.Pool(processes=NUM_PROCESSES) as pool:
        all_results = pool.map(process_worker, chunks)
    
    end_time = time.time()
    total_time = end_time - start_time
    
    # 平铺结果
    flat_results = [item for sublist in all_results for item in sublist]
    success_count = sum(flat_results)
    
    print(f"\n{'='*64}")
    print(f"  🏁 巅峰挑战结束 (10k QPS Challenge)")
    print(f"{'='*64}")
    print(f"  总请求数：  {len(flat_results)}")
    print(f"  {GREEN}成功请求：  {success_count}{RESET}")
    print(f"  总耗时：    {total_time:.2f} s")
    print(f"  {YELLOW}平均吞吐量 (QPS)：{len(flat_results)/total_time:.2f} req/s{RESET}")
    print(f"{'='*64}")
    
    r = redis.Redis(host="localhost", port=6379, password=REDIS_PASSWORD, decode_responses=True)
    final_stock = r.get(f"seckill:stock:{VOUCHER_ID}")
    print(f"  {BLUE}Redis 最终余量：{final_stock}{RESET}")
    
    if int(final_stock or 0) >= 0 and success_count <= STOCK_TO_SET:
        print(f"  {GREEN}🏆 验证通过：超大规模并发下 0 超卖！{RESET}")
    else:
        print(f"  {RED}❌ 验证失败：检测到库存异常！{RESET}")
    print(f"{'='*64}\n")

if __name__ == "__main__":
    main()
