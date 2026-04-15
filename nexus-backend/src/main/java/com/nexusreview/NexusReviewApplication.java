package com.nexusreview;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@MapperScan("com.nexusreview.mapper")
@SpringBootApplication
@EnableAspectJAutoProxy(exposeProxy = true)
public class NexusReviewApplication {

    public static void main(String[] args) {
        SpringApplication.run(NexusReviewApplication.class, args);
    }

}
