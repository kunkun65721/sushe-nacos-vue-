package com.sushepro.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.sushepro.pojo.Student;
import com.sushepro.pojo.Dormitory;
import com.sushepro.pojo.HabitQuestionnaire;
import com.sushepro.pojo.DormitoryAllocation;
import com.sushepro.pojo.RecommendationResult;
import com.sushepro.service.AIService;
import com.sushepro.service.StudentService;
import com.sushepro.service.DormitoryService;
import com.sushepro.service.HabitQuestionnaireService;
import com.sushepro.service.DormitoryAllocationService;
import com.sushepro.service.KnowledgeBaseService;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.io.entity.StringEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * AI推荐服务实现类
 */
@Service
public class AIServiceImpl implements AIService {

    @Autowired
    private StudentService studentService;
    
    @Autowired
    private DormitoryService dormitoryService;
    
    @Autowired
    private HabitQuestionnaireService habitQuestionnaireService;
    
    @Autowired
    private DormitoryAllocationService dormitoryAllocationService;

    @Autowired
    private KnowledgeBaseService knowledgeBaseService;
    
    // DeepSeek API配置
    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";
    private static final String API_KEY = "sk-0b6f9c93355a441a8c8dc45a8d891653"; // 实际的DeepSeek API密钥

    @Override
    public RecommendationResult getDormitoryRecommendation(Integer studentId, String remark) {
        try {
            // 1. 收集学生信息
            Student student = studentService.findById(studentId);
            if (student == null) {
                return new RecommendationResult("未找到该学生信息！", null);
            }

            // 2. 收集学生生活习惯
            HabitQuestionnaire habit = habitQuestionnaireService.findByStudentId(studentId);

            // 3. 收集所有宿舍信息
            List<Dormitory> dormitories = dormitoryService.findAll();

            // 4. 收集每个宿舍的学生信息
            StringBuilder dormInfoBuilder = new StringBuilder();
            for (Dormitory dorm : dormitories) {
                if (dorm.getStatus() == 1) { // 只考虑启用的宿舍
                    dormInfoBuilder.append("宿舍编号：").append(dorm.getDormitoryNumber())
                        .append(", 类型：").append(dorm.getDormitoryType())
                        .append(", 容量：").append(dorm.getCapacity())
                        .append(", 当前入住人数：").append(dorm.getCurrentOccupancy())
                        .append(", 楼栋：").append(dorm.getBuilding())
                        .append("\n");

                    // 获取宿舍内的学生信息
                    List<DormitoryAllocation> allocations = dormitoryAllocationService.findByDormitoryId(dorm.getId());
                    for (DormitoryAllocation allocation : allocations) {
                        Student dormStudent = studentService.findById(allocation.getStudentId());
                        HabitQuestionnaire dormStudentHabit = habitQuestionnaireService.findByStudentId(allocation.getStudentId());

                        dormInfoBuilder.append("  - 学生：").append(dormStudent.getName())
                            .append(", 性别：").append(dormStudent.getGender() == 0 ? "男" : "女")
                            .append(", 专业：").append(dormStudent.getMajor())
                            .append(", 年级：").append(dormStudent.getGrade())
                            .append(", 睡眠习惯：").append(dormStudentHabit != null ? dormStudentHabit.getSleepTime() : "未填写")
                            .append("-").append(dormStudentHabit != null ? dormStudentHabit.getWakeUpTime() : "未填写")
                            .append(", 吸烟：").append(dormStudentHabit != null ? (dormStudentHabit.getSmoking() == 1 ? "是" : "否") : "未填写")
                            .append(", 饮酒：").append(dormStudentHabit != null ? (dormStudentHabit.getDrinking() == 1 ? "是" : "否") : "未填写")
                            .append(", 噪音容忍度：").append(dormStudentHabit != null ? dormStudentHabit.getNoiseTolerance() : "未填写")
                            .append(", 清洁要求：").append(dormStudentHabit != null ? dormStudentHabit.getCleanliness() : "未填写")
                            .append("\n");
                    }
                }
            }

            // 5. 构建AI请求
            String prompt = buildPrompt(student, habit, dormInfoBuilder.toString(), remark);

            // 6. 调用DeepSeek API
            String rawResponse = callDeepSeekApi(prompt);

            // 7. 解析维度分数
            Map<String, Integer> scores = parseScores(rawResponse);
            String cleanText = stripScoresBlock(rawResponse);

            return new RecommendationResult(cleanText, scores);

        } catch (Exception e) {
            e.printStackTrace();
            return new RecommendationResult("获取推荐失败：" + e.getMessage(), null);
        }
    }
    
    /**
     * 构建AI请求的提示词
     */
    private String buildPrompt(Student student, HabitQuestionnaire habit, String dormInfo, String remark) {
        StringBuilder prompt = new StringBuilder();
        
        prompt.append("你是一个宿舍分配专家，请根据以下信息为学生推荐最适合的宿舍。\n\n");
        
        // 学生基本信息
        prompt.append("学生信息：\n")
            .append("- 姓名：").append(student.getName())
            .append("- 性别：").append(student.getGender() == 0 ? "男" : "女")
            .append("- 专业：").append(student.getMajor())
            .append("- 年级：").append(student.getGrade())
            .append("- 学号：").append(student.getStudentId())
            .append("\n\n");
        
        // 学生生活习惯
        prompt.append("生活习惯：\n")
            .append("- 睡眠时间：").append(habit != null ? habit.getSleepTime() : "未填写").append("\n")
            .append("- 起床时间：").append(habit != null ? habit.getWakeUpTime() : "未填写").append("\n")
            .append("- 吸烟：").append(habit != null ? (habit.getSmoking() == 1 ? "是" : "否") : "未填写").append("\n")
            .append("- 饮酒：").append(habit != null ? (habit.getDrinking() == 1 ? "是" : "否") : "未填写").append("\n")
            .append("- 噪音容忍度：").append(habit != null ? habit.getNoiseTolerance() : "未填写").append("\n")
            .append("- 清洁要求：").append(habit != null ? habit.getCleanliness() : "未填写").append("\n")
            .append("- 备注：").append(habit != null ? habit.getNote() : "无").append("\n");

        // 管理员附加要求
        if (remark != null && !remark.trim().isEmpty()) {
            prompt.append("\n管理员附加要求：\n")
                .append(remark.trim()).append("\n");
        }

        prompt.append("\n");
        
        // 宿舍信息
        prompt.append("现有宿舍信息：\n").append(dormInfo).append("\n");
        
        // 推荐要求
        prompt.append("请根据学生的性别、专业、年级和生活习惯，为其推荐1个最适合的宿舍。\n\n")
            .append("请严格按照以下格式返回结果：\n\n")
            .append("第一部分：推荐理由\n")
            .append("写出推荐宿舍编号，并给出简短推荐理由。空宿舍优先级在最后，不许推荐学生当前已入住的宿舍。\n\n")
            .append("第二部分：维度匹配分数\n")
            .append("在 [SCORES] 和 [/SCORES] 标记之间，输出一个JSON对象，包含以下六个维度的匹配分数（0-100的整数）：\n")
            .append("- sleepCompatibility: 入睡时间匹配度（越高表示该学生的入睡时间与推荐宿舍成员越接近）\n")
            .append("- wakeUpCompatibility: 起床时间匹配度（越高表示该学生的起床时间与推荐宿舍成员越接近）\n")
            .append("- smokingCompatibility: 吸烟习惯匹配度（100表示习惯相同，0表示完全冲突）\n")
            .append("- drinkingCompatibility: 饮酒习惯匹配度（100表示习惯相同，0表示完全冲突）\n")
            .append("- noiseToleranceCompatibility: 噪音耐受匹配度（越高表示与舍友在该维度越兼容）\n")
            .append("- cleanlinessCompatibility: 整洁度匹配度（越高表示与舍友在该维度越兼容）\n\n")
            .append("请务必包含 [SCORES] 和 [/SCORES] 标记，且JSON必须合法。");
        
        return prompt.toString();
    }
    
    /**
     * 从AI回复中解析维度匹配分数。
     * 查找 [SCORES]...[/SCORES] 标记中的JSON。
     * @return 维度名→分数(0-100) 的有序Map，解析失败返回null
     */
    private Map<String, Integer> parseScores(String rawText) {
        if (rawText == null || rawText.isEmpty()) {
            return null;
        }
        try {
            int start = rawText.indexOf("[SCORES]");
            int end = rawText.indexOf("[/SCORES]");
            if (start == -1 || end == -1 || end <= start) {
                return null;
            }
            String jsonStr = rawText.substring(start + "[SCORES]".length(), end).trim();

            // 处理可能包裹的 ```json ... ``` 代码块
            if (jsonStr.startsWith("```")) {
                int fenceEnd = jsonStr.indexOf("\n");
                if (fenceEnd != -1) {
                    jsonStr = jsonStr.substring(fenceEnd + 1);
                }
                if (jsonStr.endsWith("```")) {
                    jsonStr = jsonStr.substring(0, jsonStr.lastIndexOf("```")).trim();
                }
            }

            JSONObject scoresJson = JSON.parseObject(jsonStr);

            Map<String, Integer> scores = new LinkedHashMap<>();
            String[][] keyMapping = {
                {"sleepCompatibility", "入睡匹配度"},
                {"wakeUpCompatibility", "起床匹配度"},
                {"smokingCompatibility", "吸烟匹配度"},
                {"drinkingCompatibility", "饮酒匹配度"},
                {"noiseToleranceCompatibility", "噪音耐受匹配度"},
                {"cleanlinessCompatibility", "整洁度匹配度"}
            };
            for (String[] mapping : keyMapping) {
                Integer value = scoresJson.getInteger(mapping[0]);
                if (value == null) return null;
                scores.put(mapping[1], Math.max(0, Math.min(100, value)));
            }
            return scores;
        } catch (Exception e) {
            System.err.println("[AIService] Failed to parse dimension scores: " + e.getMessage());
            return null;
        }
    }

    /**
     * 从文本中移除 [SCORES]...[/SCORES] 块，返回干净的推荐文本。
     */
    private String stripScoresBlock(String rawText) {
        if (rawText == null) return "";
        String result = rawText.replaceAll("\\[SCORES\\][\\s\\S]*\\[/SCORES\\]", "").trim();
        result = result.replaceAll("```", "").trim();
        return result;
    }

    /**
     * 调用DeepSeek API（单轮对话，用于推荐）
     */
    private String callDeepSeekApi(String prompt) throws IOException, ParseException {
        JSONObject userMsg = new JSONObject();
        userMsg.put("role", "user");
        userMsg.put("content", prompt);
        List<JSONObject> messages = new ArrayList<>();
        messages.add(userMsg);
        return callDeepSeekApiMessages(messages, 8096, 0.1);
    }

    /**
     * 调用DeepSeek API（多轮对话，用于聊天）
     */
    private String callDeepSeekApiMessages(List<JSONObject> messages, int maxTokens, double temperature) throws IOException, ParseException {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(API_URL);
            httpPost.setHeader("Authorization", "Bearer " + API_KEY);
            httpPost.setHeader("Content-Type", "application/json");

            JSONObject requestBody = new JSONObject();
            requestBody.put("model", "deepseek-chat");

            JSONArray messagesArray = new JSONArray();
            for (JSONObject msg : messages) {
                messagesArray.add(msg);
            }

            requestBody.put("messages", messagesArray);
            requestBody.put("max_tokens", maxTokens);
            requestBody.put("temperature", temperature);

            StringEntity entity = new StringEntity(requestBody.toJSONString(), ContentType.APPLICATION_JSON);
            httpPost.setEntity(entity);

            System.out.println("AI请求: " + requestBody.toJSONString());

            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                String responseContent = EntityUtils.toString(response.getEntity());

                System.out.println("AI响应: " + responseContent);

                JSONObject responseJson = JSON.parseObject(responseContent);

                if (responseJson.containsKey("error")) {
                    JSONObject error = responseJson.getJSONObject("error");
                    return "API调用失败：" + error.getString("message");
                }

                if (responseJson.containsKey("choices")) {
                    JSONArray choices = responseJson.getJSONArray("choices");
                    if (choices != null && !choices.isEmpty()) {
                        JSONObject choice = choices.getJSONObject(0);
                        JSONObject messageObj = choice.getJSONObject("message");
                        return messageObj.getString("content");
                    }
                }
                return "未获取到回复，请稍后重试。";
            }
        }
    }

    @Override
    public String chat(String studentContext, List<Map<String, String>> chatHistory, String userMessage) {
        try {
            List<JSONObject> messages = new ArrayList<>();

            // 系统消息
            JSONObject systemMsg = new JSONObject();
            StringBuilder systemPrompt = new StringBuilder();
            systemPrompt.append("你是学生宿舍管理系统的AI客服助手。你的职责是帮助学生解答关于宿舍的各类问题。\n\n");

            // 知识库内容（动态加载）
            String knowledgeContent = knowledgeBaseService.getAllEnabledContentForAI();
            if (knowledgeContent != null && !knowledgeContent.isEmpty()) {
                systemPrompt.append("【知识库信息】\n以下是管理员上传的与宿舍管理相关的制度、规定和常见问题，请据此回答学生问题：\n\n")
                           .append(knowledgeContent)
                           .append("\n");
            }

            systemPrompt.append("你可以回答的问题范围包括：\n")
                .append("- 宿舍设施（房间类型、容量、楼栋位置等）\n")
                .append("- 宿舍管理规定（作息时间、访客制度、卫生要求等）\n")
                .append("- 宿舍分配流程和规则\n")
                .append("- 生活习惯问卷的填写指导\n")
                .append("- 宿舍调换的相关政策和流程\n")
                .append("- 宿舍费用相关问题\n\n")
                .append("请优先使用上述知识库内容回答问题。如果知识库中没有相关信息，请根据常识回答。\n\n")
                .append("你不能回答的问题：\n")
                .append("- 与宿舍管理无关的问题\n")
                .append("- 其他学生的个人信息\n")
                .append("- 修改系统数据的请求\n\n")
                .append("请用友好、耐心的语气回复，回复内容简洁明了，使用中文。\n\n")
                .append("以下是当前学生的个人信息，你可以在回答中引用这些信息来提供个性化帮助：\n")
                .append(studentContext)
                .append("\n\n")
                .append("现在开始回答学生的问题。");

            systemMsg.put("role", "system");
            systemMsg.put("content", systemPrompt.toString());
            messages.add(systemMsg);

            // 历史消息
            for (Map<String, String> entry : chatHistory) {
                JSONObject historyMsg = new JSONObject();
                historyMsg.put("role", entry.get("role"));
                historyMsg.put("content", entry.get("content"));
                messages.add(historyMsg);
            }

            // 当前用户消息
            JSONObject userMsg = new JSONObject();
            userMsg.put("role", "user");
            userMsg.put("content", userMessage);
            messages.add(userMsg);

            return callDeepSeekApiMessages(messages, 2048, 0.7);
        } catch (Exception e) {
            e.printStackTrace();
            return "抱歉，AI客服暂时不可用，请稍后重试。错误：" + e.getMessage();
        }
    }
}