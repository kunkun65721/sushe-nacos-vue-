package com.sushepro.controller;

import com.sushepro.dto.ApiResponse;
import com.sushepro.pojo.Student;
import com.sushepro.pojo.User;
import com.sushepro.service.AIService;
import com.sushepro.service.StudentService;
import com.sushepro.service.UserService;
import com.sushepro.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/ai")
public class AIController {

    @Autowired
    private AIService aiService;

    @Autowired
    private UserService userService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private JwtUtil jwtUtil;

    // 存储用户聊天历史
    private final Map<Integer, List<Map<String, String>>> userChatHistory = new HashMap<>();

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

    @PostMapping("/chat")
    public ApiResponse<Map<String, String>> chat(@RequestBody Map<String, Object> request,
                                                   @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        String message = (String) request.get("message");
        if (message == null || message.trim().isEmpty()) {
            return ApiResponse.error("消息不能为空");
        }

        @SuppressWarnings("unchecked")
        List<Map<String, String>> chatHistory = (List<Map<String, String>>) request.get("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }

        Student student = studentService.findByUserId(user.getId());
        String studentContext = buildStudentContext(student);
        String response = aiService.chat(studentContext, chatHistory, message);

        Map<String, String> result = new HashMap<>();
        result.put("response", response);
        return ApiResponse.success(result);
    }

    @PostMapping("/clear")
    public ApiResponse<Void> clearChat(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        userChatHistory.remove(user.getId());
        return ApiResponse.success();
    }

    private String buildStudentContext(Student student) {
        if (student == null) {
            return "未知学生";
        }
        return String.format("姓名：%s，性别：%s，专业：%s，年级：%s，学号：%s",
                student.getName(),
                student.getGender() == 0 ? "男" : "女",
                student.getMajor(),
                student.getGrade(),
                student.getStudentId());
    }
}