# 修复 "choices is null" 空指针异常问题

## 问题分析

### 错误描述
```
Cannot invoke "com.alibaba.fastjson.JSONArray.isEmpty()" because "choices" is null
```

### 根本原因
当魔搭 API 响应中包含 `"choices"` 键但对应值为 `null` 时，代码直接调用 `choices.isEmpty()` 导致空指针异常。

### 受影响文件
1. `src/main/java/com/sushepro/service/impl/AIServiceImpl.java` (第288-289行)
2. `src/main/java/com/sushepro/util/DeepSeekApiClient.java` (第62-63行)

## 修复方案

在调用 `choices.isEmpty()` 之前添加 null 检查：

### 修改前
```java
if (responseJson.containsKey("choices")) {
    JSONArray choices = responseJson.getJSONArray("choices");
    if (!choices.isEmpty()) {
        // ...
    }
}
```

### 修改后
```java
if (responseJson.containsKey("choices")) {
    JSONArray choices = responseJson.getJSONArray("choices");
    if (choices != null && !choices.isEmpty()) {
        // ...
    }
}
```

## 风险评估

| 风险 | 等级 | 说明 |
|------|------|------|
| 引入新 bug | 低 | 修改简单明确，仅添加 null 检查 |
| API 兼容性 | 低 | 不影响 API 调用逻辑，仅增强容错性 |
| 测试覆盖 | 中 | 建议测试异常响应场景 |

## 实施步骤

1. 修改 `AIServiceImpl.java` 添加 null 检查
2. 修改 `DeepSeekApiClient.java` 添加相同的 null 检查

## 验证方式

通过 AI 匹配页面测试推荐功能，确认异常响应时能够正确处理并返回友好错误提示。