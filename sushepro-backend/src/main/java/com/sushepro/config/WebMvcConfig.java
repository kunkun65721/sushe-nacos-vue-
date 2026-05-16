package com.sushepro.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 映射 uploads 目录到 /uploads/** 和 /api/uploads/** 路径
        // user.dir 默认是后端模块目录，需要回退两级到项目根目录
        String projectRoot = new File(System.getProperty("user.dir")).getParent();
        String uploadPath = projectRoot + File.separator + "uploads" + File.separator;

        // 映射 /uploads/** 到本地 uploads 目录
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath);

        // 映射 /api/uploads/** 到本地 uploads 目录（适配前端代理）
        registry.addResourceHandler("/api/uploads/**")
                .addResourceLocations("file:" + uploadPath);
    }
}