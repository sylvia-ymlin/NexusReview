package com.nexusreview.utils;

import cn.hutool.core.util.BooleanUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.github.benmanes.caffeine.cache.Cache;
import com.google.common.hash.BloomFilter;
import com.nexusreview.mq.CacheSyncProducer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;

/**
 * <p>
 * 多级缓存工具类 (L1: Caffeine, L2: Redis)
 * </p>
 */
@Slf4j
@Component
public class CacheClient {

    @Resource
    private BloomFilter<Long> bloomFilter;

    @Resource
    private Cache<String, String> localCache;

    @Resource
    @Lazy // 使用懒加载防止循环依赖
    private CacheSyncProducer cacheSyncProducer;

    private final StringRedisTemplate stringRedisTemplate;

    public CacheClient(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    /**
     * 设置多级缓存
     */
    public void set(String key, Object value, Long time, TimeUnit unit){
        String json = JSONUtil.toJsonStr(value);
        // 1. 设置 Redis (L2)
        stringRedisTemplate.opsForValue().set(key, json, time, unit);
        // 2. 设置 Caffeine (L1)
        localCache.put(key, json);
    }

    /**
     * 查询多级缓存：Caffeine -> Redis -> DB (含互斥锁与布隆过滤器)
     */
    public <R, ID> R queryWithPassThroughAndMutex(
           final String keyPrefix, final String lockKeyPrefix, ID id, Class<R> type, Function<ID, R> dbFallback,
            Long time, TimeUnit unit, Long nullValueTTL, TimeUnit nullValueUnit){
        
        String key = keyPrefix + id;

        // 1. 先查本地缓存 (L1)
        String json = localCache.getIfPresent(key);
        if (StrUtil.isNotBlank(json)) {
            log.debug("L1 缓存命中 (Caffeine): {}", key);
            return JSONUtil.toBean(json, type);
        }

        // 2. 布隆过滤器判断 id 是否存在
        if (id instanceof Long && !bloomFilter.mightContain((Long)id)) {
            log.info("布隆过滤器拦截，id: {} 不存在", id);
            return null;
        }

        while (true) {
            // 3. 从 Redis 查询 (L2)
            json = stringRedisTemplate.opsForValue().get(key);
            
            // 4. 判断 Redis 是否命中
            if (StrUtil.isNotBlank(json)) {
                log.debug("L2 缓存命中 (Redis): {}", key);
                // 写入 L1 供下次使用
                localCache.put(key, json);
                return JSONUtil.toBean(json, type);
            }

            // 5. 判断是否命中的是“缓存空值”
            if (json != null) {
                return null;
            }

            // 6. 缓存双漏，执行数据库查询并加锁
            String lockKey = lockKeyPrefix + id;
            try {
                boolean isLock = tryLock(lockKey);
                if (!isLock) {
                    // 获取锁失败，休眠重试
                    Thread.sleep(50);
                    continue;
                }
                
                // Double Check: 获取锁后再次检查 Redis
                json = stringRedisTemplate.opsForValue().get(key);
                if (StrUtil.isNotBlank(json)) {
                    localCache.put(key, json);
                    return JSONUtil.toBean(json, type);
                }

                // 查询数据库
                R result = dbFallback.apply(id);
                
                // 处理数据库不存在的情况 (缓存穿透防护)
                if (result == null) {
                    stringRedisTemplate.opsForValue().set(key, "", nullValueTTL, nullValueUnit);
                    return null;
                }

                // 写入多级缓存
                this.set(key, result, time + RandomUtil.randomInt(1, 5), unit);
                return result;

            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            } finally {
                unlock(lockKey);
            }
        }
    }

    private boolean tryLock(String key){
        Boolean flag = stringRedisTemplate.opsForValue().setIfAbsent(key, "1", 10, TimeUnit.SECONDS);
        return BooleanUtil.isTrue(flag);
    }
    
    private void unlock(String key){
        stringRedisTemplate.delete(key);
    }

    /**
     * 删除多级缓存 (L1 & L2)
     */
    public void delete(String key) {
        log.debug("清空多级缓存: {}", key);
        // 1. 清理 L1
        localCache.invalidate(key);
        // 2. 清理 L2
        stringRedisTemplate.delete(key);
    }

    /**
     * 带补偿机制的缓存删除 (若失败则发 MQ 重试)
     */
    public void deleteWithRetry(String key) {
        try {
            this.delete(key);
        } catch (Exception e) {
            log.error("缓存初次删除失败，准备进入 MQ 补偿流程. Key: {}, Error: {}", key, e.getMessage());
            cacheSyncProducer.sendDeleteRetryMessage(key);
        }
    }
}
