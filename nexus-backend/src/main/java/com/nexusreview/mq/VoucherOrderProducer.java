package com.nexusreview.mq;

import com. baomidou.mybatisplus.core.toolkit.StringUtils;
import com.nexusreview.config.KafkaConfig;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.nexusreview.entity.VoucherOrder;
import cn.hutool.json.JSONUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;

@Slf4j
@Component
public class VoucherOrderProducer {

    @Resource
    private KafkaTemplate<String, String> kafkaTemplate;

    public void sendOrderMessage(VoucherOrder order) {
        String msg = JSONUtil.toJsonStr(order);
        log.info("发送下单消息至 Kafka: {}", msg);
        kafkaTemplate.send(KafkaConfig.SEckill_ORDER_TOPIC, order.getId().toString(), msg);
    }

    public void sendOrderCancelMessage(Long orderId) {
        log.info("发送订单取消消息至 Kafka: {}", orderId);
        kafkaTemplate.send(KafkaConfig.ORDER_CANCEL_TOPIC, orderId.toString(), orderId.toString());
    }
}
