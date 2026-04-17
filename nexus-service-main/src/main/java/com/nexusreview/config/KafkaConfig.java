package com.nexusreview.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaConfig {

    public static final String SEckill_ORDER_TOPIC = "seckill.order";
    public static final String ORDER_CANCEL_TOPIC = "order.cancel";
    public static final String CACHE_DELETE_RETRY_TOPIC = "cache.delete.retry";

    /**
     * 缓存同步重试 Topic
     */
    @Bean
    public NewTopic cacheDeleteRetryTopic() {
        return TopicBuilder.name(CACHE_DELETE_RETRY_TOPIC)
                .partitions(1)
                .replicas(1)
                .build();
    }

    /**
     * 自动创建秒杀下单 Topic
     */
    @Bean
    public NewTopic seckillOrderTopic() {
        return TopicBuilder.name(SEckill_ORDER_TOPIC)
                .partitions(3) // 3个分区提升并行度
                .replicas(1)
                .build();
    }

    /**
     * 自动创建订单取消 Topic
     */
    @Bean
    public NewTopic orderCancelTopic() {
        return TopicBuilder.name(ORDER_CANCEL_TOPIC)
                .partitions(1)
                .replicas(1)
                .build();
    }
}
