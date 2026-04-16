package com.nexusreview.mq;

import cn.hutool.json.JSONUtil;
import com.nexusreview.config.KafkaConfig;
import com.nexusreview.entity.VoucherOrder;
import com.nexusreview.service.IVoucherOrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;

@Slf4j
@Component
public class VoucherOrderConsumer {

    @Resource
    private IVoucherOrderService voucherOrderService;

    /**
     * 监听秒杀下单消息
     */
    @KafkaListener(topics = KafkaConfig.SEckill_ORDER_TOPIC, groupId = "seckill-group")
    public void consumeOrderMessage(String message) {
        log.info("从 Kafka 接收到下单消息: {}", message);
        try {
            VoucherOrder order = JSONUtil.toBean(message, VoucherOrder.class);
            voucherOrderService.createVoucherOrder(order);
        } catch (Exception e) {
            log.error("下单消息消费失败", e);
        }
    }

    /**
     * 监听订单取消消息（由延迟任务触发）
     */
    @KafkaListener(topics = KafkaConfig.ORDER_CANCEL_TOPIC, groupId = "seckill-group")
    public void consumeCancelMessage(String message) {
        log.info("从 Kafka 接收到取消订单消息: {}", message);
        try {
            Long orderId = Long.valueOf(message);
            // 执行业务：关闭订单并回滚库存
            voucherOrderService.cancelVoucherOrder(orderId);
        } catch (Exception e) {
            log.error("取消订单消息消费失败", e);
        }
    }
}
