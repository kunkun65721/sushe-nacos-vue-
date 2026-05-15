package com.sushepro;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@MapperScan("com.sushepro.mapper")
@EnableDiscoveryClient
public class SusheproApplication {
    public static void main(String[] args) {
        SpringApplication.run(SusheproApplication.class, args);
    }
}