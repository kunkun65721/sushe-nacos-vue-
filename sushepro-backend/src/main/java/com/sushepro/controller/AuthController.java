package com.sushepro.controller;

import com.sushepro.dto.ApiResponse;
import com.sushepro.dto.LoginRequest;
import com.sushepro.dto.LoginResponse;
import com.sushepro.pojo.User;
import com.sushepro.service.UserService;
import com.sushepro.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@RequestBody LoginRequest request) {
        User user = userService.login(request.getUsername(), request.getPassword());

        if (user == null) {
            return ApiResponse.error("用户名或密码错误");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getRole() == 0 ? "student" : "admin");
        LoginResponse response = new LoginResponse(token, user.getId(), user.getUsername(),
                user.getRole() == 0 ? "student" : "admin");

        return ApiResponse.success(response);
    }

    @PostMapping("/logout")
    public ApiResponse<Void> logout() {
        return ApiResponse.success();
    }

    @GetMapping("/me")
    public ApiResponse<User> getCurrentUser(@RequestHeader("Authorization") String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ApiResponse.unauthorized();
        }

        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return ApiResponse.unauthorized();
        }

        Integer userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.findById(userId);

        if (user == null) {
            return ApiResponse.notFound();
        }

        return ApiResponse.success(user);
    }

    @GetMapping("/search")
    public ApiResponse<List<Map<String, Object>>> search(@RequestParam("keyword") String keyword,
                                                          @RequestHeader("Authorization") String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ApiResponse.unauthorized();
        }

        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return ApiResponse.unauthorized();
        }

        Integer userId = jwtUtil.getUserIdFromToken(token);
        String role = jwtUtil.getRoleFromToken(token);
        User user = userService.findById(userId);

        if (user == null) {
            return ApiResponse.notFound();
        }

        List<Map<String, Object>> allFeatures = new ArrayList<>();
        List<Map<String, Object>> results = new ArrayList<>();

        if ("admin".equals(role)) {
            addFeature(allFeatures, "首页", "dashboard", "系统概览数据面板", "/admin/index");
            addFeature(allFeatures, "学生管理", "group", "查看和管理所有学生信息", "/admin/student/list");
            addFeature(allFeatures, "宿舍管理", "domain", "管理宿舍楼栋和房间", "/admin/dormitory/list");
            addFeature(allFeatures, "生活问卷", "quiz", "查看学生生活习惯问卷", "/admin/habitQuestionnaire/list");
            addFeature(allFeatures, "分配管理", "assignment_turned_in", "管理宿舍分配记录", "/admin/allocation/list");
            addFeature(allFeatures, "调换管理", "swap_horiz", "审核宿舍调换申请", "/admin/transfer/list");
            addFeature(allFeatures, "报修管理", "construction", "处理学生报修申请", "/admin/repair/list");
            addFeature(allFeatures, "AI匹配", "psychology", "AI智能宿舍推荐", "/admin/ai/recommend");
            addFeature(allFeatures, "通知中心", "notifications", "查看系统通知和待处理事项", "/admin/notifications");
            addFeature(allFeatures, "帮助中心", "help", "系统使用指南", "/admin/help");
            addFeature(allFeatures, "设置", "settings", "修改账户密码", "/admin/settings");
            addFeature(allFeatures, "个人资料", "person", "查看管理员账户信息", "/admin/profile");
        } else {
            addFeature(allFeatures, "首页", "dashboard", "个人首页面板", "/student/index");
            addFeature(allFeatures, "我的资料", "person", "查看个人基本信息", "/student/profile");
            addFeature(allFeatures, "生活问卷", "quiz", "填写生活习惯问卷", "/student/habitQuestionnaire");
            addFeature(allFeatures, "宿舍分配", "king_bed", "查看宿舍分配结果", "/student/dormitoryAllocation");
            addFeature(allFeatures, "调换申请", "swap_horiz", "提交宿舍调换申请", "/student/transfer");
            addFeature(allFeatures, "报修申请", "build", "提交宿舍报修申请", "/student/repair");
            addFeature(allFeatures, "AI客服", "support_agent", "智能客服对话", "/student/aiChat");
            addFeature(allFeatures, "通知中心", "notifications", "查看个人通知和申请状态", "/student/notifications");
            addFeature(allFeatures, "帮助中心", "help", "系统使用指南", "/student/help");
            addFeature(allFeatures, "设置", "settings", "修改账户密码", "/student/settings");
        }

        String kw = keyword.toLowerCase();
        for (Map<String, Object> feature : allFeatures) {
            String name = (String) feature.get("name");
            String description = (String) feature.get("description");
            String icon = (String) feature.get("icon");
            if (name.toLowerCase().contains(kw) || description.toLowerCase().contains(kw) || icon.toLowerCase().contains(kw)) {
                results.add(feature);
            }
        }

        return ApiResponse.success(results);
    }

    private void addFeature(List<Map<String, Object>> list, String name, String icon, String description, String path) {
        Map<String, Object> feature = new HashMap<>();
        feature.put("name", name);
        feature.put("icon", icon);
        feature.put("description", description);
        feature.put("path", path);
        list.add(feature);
    }
}