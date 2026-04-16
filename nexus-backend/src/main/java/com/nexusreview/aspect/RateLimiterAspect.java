package com.nexusreview.aspect;

import com.nexusreview.annotation.RateLimit;
import cn.hutool.core.util.StrUtil;
import com.nexusreview.dto.UserDTO;
import com.nexusreview.exception.RateLimitException;
import com.nexusreview.utils.UserHolder;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;
import java.util.Collections;

@Slf4j
@Aspect
@Component
public class RateLimiterAspect {

    private final StringRedisTemplate stringRedisTemplate;
    private static final DefaultRedisScript<Long> LIMIT_SCRIPT;

    static {
        LIMIT_SCRIPT = new DefaultRedisScript<>();
        LIMIT_SCRIPT.setLocation(new ClassPathResource("limiter.lua"));
        LIMIT_SCRIPT.setResultType(Long.class);
    }

    public RateLimiterAspect(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    @Before("@annotation(rateLimit)")
    public void doBefore(JoinPoint joinPoint, RateLimit rateLimit) {
        String key = rateLimit.key();
        int time = rateLimit.time();
        int count = rateLimit.count();

        String combinedKey = buildKey(joinPoint, rateLimit);
        
        try {
            Long result = stringRedisTemplate.execute(
                    LIMIT_SCRIPT,
                    Collections.singletonList(combinedKey),
                    String.valueOf(time * 1000), // 转为毫秒
                    String.valueOf(count),
                    String.valueOf(System.currentTimeMillis())
            );

            if (result != null && result == 0) {
                log.info("限流策略触发: {}, Key: {}", rateLimit.type(), combinedKey);
                throw new RateLimitException("操作过于频繁，请稍后再试");
            }
        } catch (RateLimitException e) {
            throw e;
        } catch (Exception e) {
            log.error("限流拦截器异常", e);
            // 降级：异常时不阻塞核心业务
        }
    }

    private String buildKey(JoinPoint joinPoint, RateLimit rateLimit) {
        StringBuilder keyBuilder = new StringBuilder(rateLimit.key());
        
        // 1. 获取方法信息
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        keyBuilder.append(method.getDeclaringClass().getName())
                  .append(":")
                  .append(method.getName());

        // 2. 根据维度增加标识
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) return keyBuilder.toString();
        HttpServletRequest request = attributes.getRequest();

        switch (rateLimit.type()) {
            case USER:
                keyBuilder.append(":user:").append(getUserId());
                break;
            case IP:
                keyBuilder.append(":ip:").append(getIpAddr(request));
                break;
            case COMBINED:
                keyBuilder.append(":user:").append(getUserId())
                          .append(":ip:").append(getIpAddr(request));
                break;
            case GLOBAL:
                // 不追加标识
                break;
        }

        return keyBuilder.toString();
    }

    private String getUserId() {
        UserDTO user = UserHolder.getUser();
        return user != null ? user.getId().toString() : "anonymous";
    }

    private String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
