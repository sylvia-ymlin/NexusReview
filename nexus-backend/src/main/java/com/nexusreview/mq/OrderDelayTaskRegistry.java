package com.nexusreview.mq;

import com.nexusreview.utils.RedisConstants;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;
import java.util.Set;

@Slf4j
@Component
public class OrderDelayTaskRegistry {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Resource
    private VoucherOrderProducer orderProducer;

    private static final String DELAY_QUEUE_KEY = "order:delay:queue";

    /**
     * 注册延迟任务
     * @param orderId 订单ID
     * @param delaySeconds 延迟时间（秒）
     */
    public void registerDelayTask(Long orderId, long delaySeconds) {
        long executeTime = System.currentTimeMillis() + (delaySeconds * 1000);
        stringRedisTemplate.opsForZSet().add(DELAY_QUEUE_KEY, orderId.toString(), executeTime);
        log.info("已注册订单延迟关闭任务: ID={}, 预计执行时间={}", orderId, executeTime);
    }

    /**
     * 每秒扫描一次到期的任务
     */
    @Scheduled(fixedDelay = 1000)
    public void pollExpiredTasks() {
        long now = System.currentTimeMillis();
        // 取出分值小于等于当前时间的消息
        Set<String> expiredOrderIds = stringRedisTemplate.opsForZSet().rangeByScore(DELAY_QUEUE_KEY, 0, now);
        
        if (expiredOrderIds == null || expiredOrderIds.isEmpty()) {
            return;
        }

        for (String orderIdStr : expiredOrderIds) {
            // 1. 尝试从 ZSet 移除（防止多实例并发处理）
            Long removed = stringRedisTemplate.opsForZSet().remove(DELAY_QUEUE_KEY, orderIdStr);
            if (removed != null && removed > 0) {
                log.info("检测到订单到期，触发取消流程: {}", orderIdStr);
                // 2. 发送取消消息至 Kafka
                orderProducer.sendOrderCancelMessage(Long.valueOf(orderIdStr));
            }
        }
    }
}
