import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter, Rate, Trend } from 'k6/metrics';

// ============================================================
// 压测场景配置
// ============================================================
export const options = {
  scenarios: {
    // 场景一：阶梯爬坡（找系统极限）
    ramp_up: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '30s', target: 200 },   // 30s 内爬到 200 VU
        { duration: '60s', target: 500 },   // 再 60s 爬到 500 VU
        { duration: '30s', target: 1000 },  // 再 30s 冲到 1000 VU
        { duration: '30s', target: 0 },     // 降回 0
      ],
    },
  },
  thresholds: {
    // SLA 指标阈值
    http_req_duration: ['p(95)<500', 'p(99)<1000'],  // P95 < 500ms, P99 < 1s
    http_req_failed: ['rate<0.05'],                    // 错误率 < 5%（超卖/库存不足不算错误）
    seckill_success_rate: ['rate>0'],                  // 至少有成功案例
  },
};

// 自定义指标
const seckillSuccess = new Counter('seckill_success');
const seckillFail    = new Counter('seckill_fail');
const stockEmpty     = new Counter('stock_empty');
const duplicateOrder = new Counter('duplicate_order');
const seckillSuccessRate = new Rate('seckill_success_rate');
const seckillLatency = new Trend('seckill_latency_ms');

// ============================================================
// 从环境变量读取 token 列表（由 gen_tokens.py 生成）
// ============================================================
const tokens = JSON.parse(open('/tokens/tokens.json'));
const BASE_URL = 'http://nexus-nginx:8080/api';
const VOUCHER_ID = 10;

export default function () {
  // 每个 VU 随机选一个 token
  const token = tokens[Math.floor(Math.random() * tokens.length)];

  const params = {
    headers: { 'authorization': token },
    timeout: '10s',
  };

  const start = Date.now();
  const res = http.post(`${BASE_URL}/voucher-order/seckill/${VOUCHER_ID}`, null, params);
  const latency = Date.now() - start;
  seckillLatency.add(latency);

  let body = {};
  try { body = JSON.parse(res.body); } catch {}

  if (res.status === 200 && body.success === true) {
    seckillSuccess.add(1);
    seckillSuccessRate.add(true);
  } else {
    seckillFail.add(1);
    seckillSuccessRate.add(false);
    const msg = body.errorMsg || '';
    if (msg.includes('库存不足') || msg.includes('stock')) stockEmpty.add(1);
    if (msg.includes('重复')   || msg.includes('duplicate')) duplicateOrder.add(1);
  }

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response has json': (r) => r.headers['Content-Type'] && r.headers['Content-Type'].includes('json'),
  });

  sleep(0.01); // 模拟真实用户间隔
}

export function handleSummary(data) {
  return {
    '/tokens/k6-report-summary.json': JSON.stringify(data, null, 2),
  };
}
