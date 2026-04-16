package com.nexusreview.config;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
public class CaffeineConfig {

    @Bean
    public Cache<String, String> localCache() {
        return Caffeine.newBuilder()
                // 初始容量
                .initialCapacity(100)
                // 最大容量（由LRU回收）
                .maximumSize(1000)
                // 过期时间：写入后5分钟失效（通常L1缓存TTL远小于L2 Redis）
                .expireAfterWrite(5, TimeUnit.MINUTES)
                .build();
    }
}
