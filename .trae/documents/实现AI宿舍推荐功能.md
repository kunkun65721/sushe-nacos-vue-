# 实现AI宿舍推荐功能

## 1. 功能需求
- 添加一个界面，输入学生编号
- AI读取所有宿舍信息和宿舍内学生信息
- 调用DeepSeek API给出最适合的宿舍建议

## 2. 技术架构
- 基于现有的SSM（Spring+SpringMVC+MyBatis）架构
- 使用HttpClient调用DeepSeek API
- JSP页面展示结果

## 3. 实现步骤

### 3.1 添加HTTP客户端依赖
在`pom.xml`中添加HttpClient依赖，用于调用DeepSeek API：
```xml
<dependency>
    <groupId>org.apache.httpcomponents.client5</groupId>
    <artifactId>httpclient5</artifactId>
    <version>5.3</version>
</dependency>
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>2.0.43</version>
</dependency>
```

### 3.2 创建DeepSeek API客户端工具类
创建`DeepSeekApiClient`工具类，用于处理与DeepSeek API的交互：
- 实现API调用方法
- 处理请求和响应
- 配置API密钥

### 3.3 添加控制器方法
在`AdminController`中添加新的控制器方法：
- `@GetMapping("/ai/recommend")` - 跳转到AI推荐页面
- `@PostMapping("/ai/recommend")` - 处理AI推荐请求

### 3.4 实现AI推荐服务
在`DormitoryAllocationService`中添加AI推荐方法：
- 获取所有宿舍信息
- 获取所有学生信息
- 构建AI请求参数
- 调用DeepSeek API
- 解析AI响应

### 3.5 创建JSP页面
创建`admin/ai/recommend.jsp`页面：
- 学生编号输入表单
- 推荐结果展示区域
- 宿舍详情展示

## 4. 数据流程
1. 用户在页面输入学生编号并提交
2. 控制器获取学生信息
3. 服务层获取所有宿舍和学生数据
4. 构建Prompt调用DeepSeek API
5. API返回推荐结果
6. 页面展示推荐结果

## 5. 关键代码实现

### 5.1 DeepSeekApiClient.java
```java
public class DeepSeekApiClient {
    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";
    private static final String API_KEY = "your_api_key"; // 替换为实际API密钥
    
    public String getDormitoryRecommendation(String prompt) {
        // 实现API调用逻辑
    }
}
```

### 5.2 AdminController.java新增方法
```java
@GetMapping("/ai/recommend")
public String toAiRecommend() {
    return "admin/ai/recommend";
}

@PostMapping("/ai/recommend")
public String aiRecommend(@RequestParam("studentId") Integer studentId, Model model) {
    // 实现AI推荐逻辑
    return "admin/ai/recommend";
}
```

### 5.3 DormitoryAllocationService.java新增方法
```java
public String getAiRecommendation(Integer studentId) {
    // 获取学生信息
    // 获取所有宿舍信息
    // 构建Prompt
    // 调用DeepSeek API
    // 返回推荐结果
}
```

## 6. 页面设计
- 简洁的学生编号输入表单
- 推荐结果展示区域，包括推荐宿舍、推荐理由
- 宿舍详情展示，包括宿舍号、类型、容量、当前入住人数、已入住学生信息

## 7. 安全考虑
- API密钥安全管理
- 输入参数验证
- 异常处理
- 响应结果过滤

## 8. 测试计划
- 测试API调用功能
- 测试不同学生的推荐结果
- 测试异常情况处理
- 测试页面展示效果

## 9. 注意事项
- 确保DeepSeek API密钥正确配置
- 优化Prompt设计，提高推荐准确性
- 考虑API调用频率限制
- 实现适当的缓存机制，减少API调用次数