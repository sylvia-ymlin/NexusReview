package com.nexusreview.config;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.binder.cache.CaffeineCacheMetrics;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.Resource;
import java.util.concurrent.TimeUnit;

@Configuration
public class CaffeineConfig {

    @Resource
    private MeterRegistry meterRegistry;

    @Bean
    public Cache<String, String> localCache() {
        Cache<String, String> cache = Caffeine.newBuilder()
                .initialCapacity(100)
                .maximumSize(1000)
                .expireAfterWrite(5, TimeUnit.MINUTES)
                .recordStats() // 启用指标统计
                .build();
        
        // 绑定到 Micrometer 注册表
        CaffeineCacheMetrics.monitor(meterRegistry, cache, "localCache");
        return cache;
    }
}
