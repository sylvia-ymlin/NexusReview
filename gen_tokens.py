#!/usr/bin/env python3
"""预生成 1000 个用户 Token，存入 tokens.json 供 k6 压测使用"""
import requests, redis, time, json, random
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE_URL = "http://localhost:8080/api"
SUPPORT_URL = "http://localhost:8081/support"
REDIS_PASSWORD = "123321"
TARGET = 5000  # 生成多少个 token

r = redis.Redis(host="localhost", port=6379, password=REDIS_PASSWORD, decode_responses=True)

def get_token(phone):
    try:
        requests.post(f"{BASE_URL}/user/code", params={"phone": phone}, timeout=10)
        time.sleep(0.2)
        code = requests.get(f"{SUPPORT_URL}/get-code", params={"phone": phone}, timeout=5)
        c = code.json().get("data", {}).get("code")
        if not c:
            return None
        login = requests.post(f"{BASE_URL}/user/login", json={"phone": phone, "code": c}, timeout=10)
        token = login.json().get("data")
        return token
    except:
        return None

print(f"正在生成 {TARGET} 个 token（20 个并发）...")
phones = [f"150{random.randint(10000000, 99999999)}" for _ in range(TARGET)]
tokens = []

with ThreadPoolExecutor(max_workers=20) as executor:
    futures = {executor.submit(get_token, p): p for p in phones}
    done = 0
    for f in as_completed(futures):
        token = f.result()
        done += 1
        if token:
            tokens.append(token)
        if done % 100 == 0:
            print(f"  进度：{done}/{TARGET}，有效 token：{len(tokens)}")

with open("tokens.json", "w") as f:
    json.dump(tokens, f)

print(f"\n✅ 完成！生成 {len(tokens)} 个有效 token → tokens.json")
