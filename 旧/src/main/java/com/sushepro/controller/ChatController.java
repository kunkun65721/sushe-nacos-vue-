package com.sushepro.controller;

import com.alibaba.fastjson.JSON;
import com.sushepro.pojo.DormitoryAllocation;
import com.sushepro.pojo.HabitQuestionnaire;
import com.sushepro.pojo.Student;
import com.sushepro.pojo.User;
import com.sushepro.service.AIService;
import com.sushepro.service.DormitoryAllocationService;
import com.sushepro.service.HabitQuestionnaireService;
import com.sushepro.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/student/chat")
public class ChatController {

    @Autowired
    private AIService aiService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private DormitoryAllocationService dormitoryAllocationService;

    @Autowired
    private HabitQuestionnaireService habitQuestionnaireService;

    @PostMapping("/send")
    public void sendMessage(@RequestParam("message") String userMessage,
                            HttpSession session,
                            HttpServletResponse response) throws IOException {
        Map<String, Object> result = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("error", "未登录");
                writeJson(response, result);
                return;
            }

            if (userMessage == null || userMessage.trim().isEmpty()) {
                result.put("success", false);
                result.put("error", "消息不能为空");
                writeJson(response, result);
                return;
            }

            Student student = studentService.findByUserId(user.getId());
            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());

            String context = buildStudentContext(student, allocation, questionnaire);

            @SuppressWarnings("unchecked")
            List<Map<String, String>> history =
                (List<Map<String, String>>) session.getAttribute("chatHistory");
            if (history == null) {
                history = new ArrayList<>();
            }

            String reply = aiService.chat(context, history, userMessage.trim());

            Map<String, String> userEntry = new HashMap<>();
            userEntry.put("role", "user");
            userEntry.put("content", userMessage.trim());
            history.add(userEntry);

            Map<String, String> assistantEntry = new HashMap<>();
            assistantEntry.put("role", "assistant");
            assistantEntry.put("content", reply);
            history.add(assistantEntry);

            if (history.size() > 40) {
                history.remove(0);
                history.remove(0);
            }

            session.setAttribute("chatHistory", history);

            result.put("success", true);
            result.put("reply", reply);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        writeJson(response, result);
    }

    @PostMapping("/clear")
    public void clearChat(HttpSession session, HttpServletResponse response) throws IOException {
        session.removeAttribute("chatHistory");
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        writeJson(response, result);
    }

    private String buildStudentContext(Student student, DormitoryAllocation allocation,
                                        HabitQuestionnaire questionnaire) {
        StringBuilder ctx = new StringBuilder();
        ctx.append("- 姓名：").append(student.getName()).append("\n");
        ctx.append("- 性别：").append(student.getGender() == 0 ? "男" : "女").append("\n");
        ctx.append("- 专业：").append(student.getMajor()).append("\n");
        ctx.append("- 年级：").append(student.getGrade()).append("\n");
        ctx.append("- 学号：").append(student.getStudentId()).append("\n");

        if (allocation != null) {
            ctx.append("宿舍分配：").append(allocation.getBuilding())
               .append(" ").append(allocation.getDormitoryNumber())
               .append("（").append(allocation.getDormitoryType()).append("）\n");
        } else {
            ctx.append("宿舍分配：暂未分配\n");
        }

        if (questionnaire != null) {
            ctx.append("生活习惯：睡眠").append(questionnaire.getSleepTime())
               .append("-").append(questionnaire.getWakeUpTime())
               .append("，吸烟").append(questionnaire.getSmoking() == 1 ? "是" : "否")
               .append("，饮酒").append(questionnaire.getDrinking() == 1 ? "是" : "否")
               .append("，噪音容忍度").append(questionnaire.getNoiseTolerance())
               .append("/5，清洁要求").append(questionnaire.getCleanliness()).append("/5\n");
        } else {
            ctx.append("生活习惯问卷：未填写\n");
        }

        return ctx.toString();
    }

    private void writeJson(HttpServletResponse response, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter writer = response.getWriter();
        writer.write(JSON.toJSONString(data));
        writer.flush();
    }
}
