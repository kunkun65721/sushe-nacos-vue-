package com.sushepro;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.sushepro.mapper")
public class SusheproApplication {
    public static void main(String[] args) {
        SpringApplication.run(SusheproApplication.class, args);
    }
}