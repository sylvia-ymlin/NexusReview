package com.nexusreview.mq;

import com.nexusreview.config.KafkaConfig;
import com.nexusreview.utils.CacheClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;

/**
 * 缓存同步补偿消息消费者
 */
@Slf4j
@Component
public class CacheSyncConsumer {

    @Resource
    private CacheClient cacheClient;

    /**
     * 监听到补偿消息后，执行缓存删除重试
     * @param key 缓存Key
     */
    @KafkaListener(topics = KafkaConfig.CACHE_DELETE_RETRY_TOPIC, groupId = "cache-sync-group")
    public void consumeDeleteRetry(String key) {
        log.info("接收到缓存补偿消息，准备重试删除: {}", key);
        try {
            // 执行最终删除
            cacheClient.delete(key);
            log.info("缓存补偿重试成功: {}", key);
        } catch (Exception e) {
            log.error("缓存补偿重试失败! Key: {}, Error: {}", key, e.getMessage());
            // 生产环境下可以记录死信队列或配合最大重试次数
        }
    }
}
