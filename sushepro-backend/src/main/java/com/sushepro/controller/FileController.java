package com.sushepro.controller;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/uploads")
public class FileController {

    @GetMapping("/{subDir}/{fileName:.+}")
    public ResponseEntity<Resource> serveFile(@PathVariable String subDir, @PathVariable String fileName) throws IOException {
        // 获取项目根目录
        String projectRoot = new File(System.getProperty("user.dir")).getParent();
        String fullPath = projectRoot + File.separator + "uploads" + File.separator + subDir + File.separator + fileName;

        Path path = Paths.get(fullPath);
        if (!Files.exists(path)) {
            return ResponseEntity.notFound().build();
        }

        // 对于 TXT 文件，直接读取内容并以 UTF-8 返回
        if (fileName.endsWith(".txt") || fileName.endsWith(".md")) {
            String content = Files.readString(path, StandardCharsets.UTF_8);
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("text/plain;charset=UTF-8"))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
                    .body(new org.springframework.core.io.ByteArrayResource(content.getBytes(StandardCharsets.UTF_8)));
        }

        // 对于 PDF，使用 inline
        if (fileName.endsWith(".pdf")) {
            Resource resource = new UrlResource(path.toUri());
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
                    .body(resource);
        }

        // 对于 Office 文件，使用 attachment 下载
        if (fileName.endsWith(".doc") || fileName.endsWith(".docx")) {
            Resource resource = new UrlResource(path.toUri());
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("application/msword"))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .body(resource);
        }

        if (fileName.endsWith(".xls") || fileName.endsWith(".xlsx")) {
            Resource resource = new UrlResource(path.toUri());
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("application/vnd.ms-excel"))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .body(resource);
        }

        // 其他文件直接下载
        Resource resource = new UrlResource(path.toUri());
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                .body(resource);
    }
}