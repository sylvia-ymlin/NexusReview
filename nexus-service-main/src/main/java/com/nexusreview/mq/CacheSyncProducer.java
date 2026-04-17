package com.nexusreview.mq;

import com.nexusreview.config.KafkaConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;

/**
 * 缓存同步补偿消息生产者
 */
@Slf4j
@Component
public class CacheSyncProducer {

    @Resource
    private KafkaTemplate<String, String> kafkaTemplate;

    /**
     * 发送缓存删除重试消息
     * @param key 缓存Key
     */
    public void sendDeleteRetryMessage(String key) {
        log.info("发送缓存删除补偿消息, Key: {}", key);
        kafkaTemplate.send(KafkaConfig.CACHE_DELETE_RETRY_TOPIC, key);
    }
}
