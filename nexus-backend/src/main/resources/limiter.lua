-- Key: 限流资源标识
local key = KEYS[1]
-- Window: 窗口时间（毫秒）
local window = tonumber(ARGV[1])
-- Limit: 最大请求量
local limit = tonumber(ARGV[2])
-- Now: 当前时间戳（毫秒）
local now = tonumber(ARGV[3])

-- 1. 移除窗口外的老请求数据
redis.call('ZREMRANGEBYSCORE', key, 0, now - window)

-- 2. 获取当前窗口内的请求数
local count = redis.call('ZCARD', key)

-- 3. 判断是否超过限制
if count < limit then
    -- 未超限，记录本次请求
    -- 使用随机值区分同一毫秒内的不同请求
    local random = math.random(1000, 9999)
    redis.call('ZADD', key, now, now .. ":" .. random)
    -- 设置过期时间（窗口时间的两倍，确保冗余清理）
    redis.call('EXPIRE', key, math.ceil(window / 1000) * 2)
    return 1
else
    -- 已超限
    return 0
end
