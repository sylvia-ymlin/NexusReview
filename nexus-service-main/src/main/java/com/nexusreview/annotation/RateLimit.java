package com.nexusreview.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 自定义限流注解
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RateLimit {
    
    /**
     * 限流资源Key的前缀
     */
    String key() default "rate_limit:";

    /**
     * 窗口时间（秒）
     */
    int time() default 1;

    /**
     * 窗口内允许的最大请求数
     */
    int count() default 100;

    /**
     * 限流策略
     */
    LimitType type() default LimitType.COMBINED;

    enum LimitType {
        /**
         * 针对特定用户ID限流
         */
        USER,
        /**
         * 针对请求IP限流
         */
        IP,
        /**
         * 用户ID + IP 联合限流
         */
        COMBINED,
        /**
         * 全局接口限流
         */
        GLOBAL
    }
}
