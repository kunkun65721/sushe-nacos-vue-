package com.sushepro.util;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.io.entity.StringEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class DeepSeekApiClient {
    private static final Logger logger = LoggerFactory.getLogger(DeepSeekApiClient.class);
    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";
    private static final String API_KEY = "sk-0b6f9c93355a441a8c8dc45a8d891653";

    public String getDormitoryRecommendation(String prompt) {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(API_URL);
            httpPost.setHeader("Authorization", "Bearer " + API_KEY);
            httpPost.setHeader("Content-Type", "application/json");

            JSONObject requestBody = new JSONObject();
            requestBody.put("model", "deepseek-chat");

            JSONArray messages = new JSONArray();
            JSONObject message = new JSONObject();
            message.put("role", "user");
            message.put("content", prompt);
            messages.add(message);

            requestBody.put("messages", messages);
            requestBody.put("max_tokens", 2048);
            requestBody.put("temperature", 0.7);

            StringEntity entity = new StringEntity(requestBody.toJSONString(), ContentType.APPLICATION_JSON);
            httpPost.setEntity(entity);

            logger.info("API请求: " + requestBody.toJSONString());

            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                String responseContent = EntityUtils.toString(response.getEntity());
                logger.info("API响应: " + responseContent);
                JSONObject responseJson = JSON.parseObject(responseContent);

                if (responseJson.containsKey("error")) {
                    logger.error("API错误: " + responseContent);
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
                return "未获取到推荐结果，请检查API配置或稍后重试。";
            } catch (ParseException e) {
                logger.error("解析响应失败: " + e.getMessage());
                e.printStackTrace();
                return "API响应解析失败：" + e.getMessage();
            }
        } catch (IOException e) {
            logger.error("API调用失败: " + e.getMessage());
            e.printStackTrace();
            return "API调用失败：" + e.getMessage();
        }
    }
}