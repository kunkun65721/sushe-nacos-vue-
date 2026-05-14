package com.sushepro.service;

import com.sushepro.pojo.RecommendationResult;

import java.util.List;
import java.util.Map;

/**
 * AI推荐服务接口
 */
public interface AIService {
    /**
     * 获取宿舍推荐
     * @param studentId 学生ID
     * @return 推荐结果（包含文本和维度匹配分数）
     */
    RecommendationResult getDormitoryRecommendation(Integer studentId, String remark);

    /**
     * AI客服聊天
     * @param studentContext 学生上下文信息
     * @param chatHistory 当前会话的对话历史
     * @param userMessage 用户最新消息
     * @return AI回复内容
     */
    String chat(String studentContext, List<Map<String, String>> chatHistory, String userMessage);
}