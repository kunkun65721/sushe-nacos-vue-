# 保护 API Key 并上传到 GitHub 的计划

## 现状分析

项目中有以下敏感信息需要保护：

1. `src/main/resources/db.properties` - 数据库用户名/密码
2. `src/main/java/com/sushepro/util/DeepSeekApiClient.java` - DeepSeek API KEY (`sk-0b6f9c93355a441a8c8dc45a8d891653`)

## 实施步骤

### 步骤 1：创建配置文件模板

* 创建 `src/main/resources/db.properties.example`，包含原内容但将密码替换为占位符（如 `YOUR_DB_PASSWORD`）

### 步骤 2：修改 `db.properties` 改用环境变量

* 修改 `db.properties` 使用 `${ENV_VAR}` 方式读取敏感值

* 或将 `db.properties` 加入 `.gitignore`

### 步骤 3：修改 `DeepSeekApiClient.java`

* 将硬编码的 API KEY 改为从环境变量读取：`System.getenv("DEEPSEEK_API_KEY")`

* 或创建类似 `config.properties` 的配置文件并加入 `.gitignore`

### 步骤 4：完善 `.gitignore`

* 确保以下内容在 `.gitignore` 中：

  ```
  src/main/resources/db.properties
  src/main/resources/config.properties
  src/main/resources/*.local.properties
  ```

### 步骤 5：创建使用说明文档（可选）

* 在项目中添加 `SETUP.md` 或在 `README.md` 中说明如何配置环境变量

## 推荐方案

**环境变量方案**（最安全）：

1. 敏感配置通过 `System.getenv("KEY")` 读取
2. 配置文件加入 `.gitignore`
3. 提供 `.env.example` 或文档说明需要哪些环境变量

