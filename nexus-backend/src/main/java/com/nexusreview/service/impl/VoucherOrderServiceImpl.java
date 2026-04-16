package com.nexusreview.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.nexusreview.annotation.RateLimit;
import com.nexusreview.dto.Result;
import com.nexusreview.entity.VoucherOrder;
import com.nexusreview.mapper.VoucherOrderMapper;
import com.nexusreview.mq.OrderDelayTaskRegistry;
import com.nexusreview.mq.VoucherOrderProducer;
import com.nexusreview.service.ISeckillVoucherService;
import com.nexusreview.service.IVoucherOrderService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.nexusreview.utils.RedisIdWorker;
import com.nexusreview.utils.UserHolder;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.Collections;

@Slf4j
@Service
public class VoucherOrderServiceImpl extends ServiceImpl<VoucherOrderMapper, VoucherOrder> implements IVoucherOrderService {

    @Resource
    private ISeckillVoucherService seckillVoucherService;
    @Resource
    private RedisIdWorker redisIdWorker;
    @Resource
    private RedissonClient redissonClient;
    @Resource
    private StringRedisTemplate stringRedisTemplate;
    
    @Resource
    private VoucherOrderProducer voucherOrderProducer;
    @Resource
    private OrderDelayTaskRegistry delayTaskRegistry;

    private static final DefaultRedisScript<Long> SECKILL_SCRIPT;

    static {
        SECKILL_SCRIPT = new DefaultRedisScript<>();
        SECKILL_SCRIPT.setLocation(new ClassPathResource("seckill.lua"));
        SECKILL_SCRIPT.setResultType(Long.class);
    }

    /**
     * 秒杀下单（Kafka 异步版 + 限流防护）
     */
    @Override
    @RateLimit(type = RateLimit.LimitType.COMBINED, count = 2, time = 5) // 5秒内允许2次尝试
    public Result seckillVoucher(Long voucherId) {
        Long userId = UserHolder.getUser().getId();
        long orderId = redisIdWorker.nextId("order");

        // 1.执行 Lua 脚本（原子性判断库存与资格）
        Long result = stringRedisTemplate.execute(
                SECKILL_SCRIPT,
                Collections.emptyList(),
                voucherId.toString(), userId.toString(), String.valueOf(orderId)
        );
        
        int r = result.intValue();
        if (r != 0) {
            return Result.fail(r == 1 ? "库存不足" : "不能重复下单");
        }

        // 2. 封装订单并发送至 Kafka (异步处理)
        VoucherOrder order = new VoucherOrder();
        order.setId(orderId);
        order.setUserId(userId);
        order.setVoucherId(voucherId);
        voucherOrderProducer.sendOrderMessage(order);

        // 3. 注册延迟关闭任务（15分钟，测试改为 60 秒演示）
        delayTaskRegistry.registerDelayTask(orderId, 60);

        return Result.ok(orderId);
    }

    /**
     * 真正落库：由 Kafka 消费者异步调用
     */
    @Override
    @Transactional
    public void createVoucherOrder(VoucherOrder voucherOrder) {
        Long userId = voucherOrder.getUserId();

        // 为防止异步重复分发，再次使用分布式锁（幂等）
        RLock redisLock = redissonClient.getLock("lock:order:" + userId);
        boolean isLock = redisLock.tryLock();
        if (!isLock) {
            log.warn("检测到重复下单请求，用户ID: {}", userId);
            return;
        }

        try {
            // 数据库层面再次校验
            Long count = query().eq("user_id", userId).eq("voucher_id", voucherOrder.getVoucherId()).count();
            if (count > 0) {
                return;
            }

            // 扣减库存
            boolean success = seckillVoucherService.update()
                    .setSql("stock = stock - 1")
                    .eq("voucher_id", voucherOrder.getVoucherId()).gt("stock", 0)
                    .update();
            
            if (!success) {
                log.error("数据库库存扣减失败！ID: {}", voucherOrder.getVoucherId());
                return;
            }

            // 保存订单
            save(voucherOrder);
        } finally {
            redisLock.unlock();
        }
    }

    /**
     * 订单超时取消逻辑
     */
    @Override
    @Transactional
    public void cancelVoucherOrder(Long orderId) {
        // 1. 查询订单状态
        VoucherOrder order = getById(orderId);
        if (order == null || order.getStatus() != 1) { // 假设1为未支付
            log.info("订单不需要取消: ID={}, Status={}", orderId, order != null ? order.getStatus() : "NULL");
            return;
        }

        // 2. 更新状态为已取消 (4)
        boolean success = update().set("status", 4).eq("id", orderId).eq("status", 1).update();
        if (success) {
            log.info("已置订单为取消状态: {}", orderId);
            // 3. 回滚 Redis 库存
            stringRedisTemplate.opsForValue().increment("seckill:stock:" + order.getVoucherId());
            // 4. 回滚数据库库存
            seckillVoucherService.update().setSql("stock = stock + 1")
                    .eq("voucher_id", order.getVoucherId()).update();
            log.info("库存回滚完成: VoucherID={}", order.getVoucherId());
        }
    }
}