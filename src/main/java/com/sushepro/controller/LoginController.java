package com.sushepro.controller;

import com.sushepro.pojo.User;
import com.sushepro.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class LoginController {
    
    @Autowired
    private UserService userService;
    
    // 跳转到登录页面
    @GetMapping("/login")
    public String toLogin() {
        return "login";
    }
    
    // 处理登录请求
    @PostMapping("/login")
    public String login(@RequestParam("username") String username,
                        @RequestParam("password") String password,
                        HttpSession session) {
        // 调用Service层进行登录验证
        User user = userService.login(username, password);
        
        if (user != null) {
            // 登录成功，将用户信息存入session
            session.setAttribute("user", user);
            
            // 根据用户角色跳转到不同页面
            if (user.getRole() == 0) {
                // 学生角色，跳转到学生首页
                return "redirect:/student/index";
            } else if (user.getRole() == 1) {
                // 管理员角色，跳转到管理员首页
                return "redirect:/admin/index";
            }
        }
        
        // 登录失败，返回登录页面
        return "login";
    }
    
    // 处理退出登录请求
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 清除session中的用户信息
        session.invalidate();

        // 跳转到登录页面
        return "redirect:/login";
    }

    // 功能搜索
    @GetMapping("/search")
    public String search(@RequestParam("keyword") String keyword, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("keyword", keyword);

        // 定义系统功能映射
        List<Map<String, String>> allFeatures = new ArrayList<>();

        if (user.getRole() == 1) {
            // 管理员功能
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
            // 学生功能
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

        // 模糊匹配
        List<Map<String, String>> results = new ArrayList<>();
        String kw = keyword.toLowerCase();
        for (Map<String, String> feature : allFeatures) {
            if (feature.get("name").toLowerCase().contains(kw)
                    || feature.get("description").toLowerCase().contains(kw)
                    || feature.get("icon").toLowerCase().contains(kw)) {
                results.add(feature);
            }
        }

        model.addAttribute("results", results);
        model.addAttribute("role", user.getRole() == 1 ? "admin" : "student");
        return "common/search";
    }

    private void addFeature(List<Map<String, String>> list, String name, String icon, String description, String path) {
        Map<String, String> feature = new HashMap<>();
        feature.put("name", name);
        feature.put("icon", icon);
        feature.put("description", description);
        feature.put("path", path);
        list.add(feature);
    }
}