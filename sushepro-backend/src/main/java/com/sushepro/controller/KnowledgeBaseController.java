package com.sushepro.controller;

import com.sushepro.dto.ApiResponse;
import com.sushepro.pojo.KnowledgeBase;
import com.sushepro.pojo.User;
import com.sushepro.service.KnowledgeBaseService;
import com.sushepro.service.UserService;
import com.sushepro.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/knowledge-base")
public class KnowledgeBaseController {

    @Autowired
    private KnowledgeBaseService knowledgeBaseService;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    private User getUserFromToken(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return null;
        }
        Integer userId = jwtUtil.getUserIdFromToken(token);
        return userService.findById(userId);
    }

    @PostMapping("/upload")
    public ApiResponse<Map<String, Object>> upload(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "category", defaultValue = "general") String category,
            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> result = knowledgeBaseService.uploadDocument(file, title, category);
        if ((Boolean) result.get("success")) {
            return ApiResponse.success(result);
        } else {
            return ApiResponse.error((String) result.get("message"));
        }
    }

    @GetMapping("/list")
    public ApiResponse<Map<String, Object>> getList(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "20") int size,
            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        List<KnowledgeBase> list = knowledgeBaseService.getDocumentList(category, status, page, size);
        int total = knowledgeBaseService.getDocumentCount(category, status);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);

        return ApiResponse.success(result);
    }

    @GetMapping("/{id}")
    public ApiResponse<KnowledgeBase> getDetail(
            @PathVariable Integer id,
            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        KnowledgeBase doc = knowledgeBaseService.getDocumentById(id);
        if (doc == null) {
            return ApiResponse.notFound();
        }
        return ApiResponse.success(doc);
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(
            @PathVariable Integer id,
            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        boolean success = knowledgeBaseService.deleteDocument(id);
        if (success) {
            return ApiResponse.success();
        } else {
            return ApiResponse.notFound();
        }
    }

    @PutMapping("/{id}/status")
    public ApiResponse<Void> updateStatus(
            @PathVariable Integer id,
            @RequestParam Integer status,
            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        boolean success = knowledgeBaseService.updateStatus(id, status);
        if (success) {
            return ApiResponse.success();
        } else {
            return ApiResponse.error("更新状态失败");
        }
    }
}