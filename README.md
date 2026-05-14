# 宿舍管理系统 - 分布式架构版

基于 SSM 单体应用改造的轻量级分布式架构，采用前后端分离设计。

## 技术栈

### 后端
- Spring Boot 3.2.5
- MyBatis 3.0.3
- Nacos（注册中心 + 配置中心）
- JWT（认证）
- Druid（连接池）

### 前端
- Vue 3.4
- Element Plus 2.6
- Vite 5.2
- Pinia（状态管理）
- Vue Router 4

## 项目结构

```
sushepro/
├── sushepro-backend/          # 后端服务
│   ├── src/main/java/
│   │   └── com/sushepro/
│   │       ├── controller/     # REST API控制器
│   │       ├── service/       # 业务逻辑（复用原有）
│   │       ├── mapper/        # 数据访问（复用原有）
│   │       ├── pojo/          # 实体类（复用原有）
│   │       └── dto/           # 数据传输对象
│   └── src/main/resources/
│       ├── application.yml    # Spring Boot配置
│       └── mapper/            # MyBatis映射文件
│
├── sushepro-frontend/          # 前端应用
│   ├── src/
│   │   ├── api/               # API调用层
│   │   ├── views/             # 页面组件
│   │   ├── router/            # 路由配置
│   │   └── stores/            # 状态管理
│   └── package.json
│
└── README.md                   # 本文件
```

## 快速启动

### 环境要求

- JDK 21+
- Node.js 18+
- Maven 3.8+
- MySQL 8.0+
- Nacos 2.x

### 1. 启动 MySQL

确保 MySQL 运行中，数据库 `susheguanli` 已创建。

### 2. 启动 Nacos

下载 [Nacos](https://nacos.io/download/nacos/) 后运行：

```bash
# Linux/Mac
sh startup.sh -m standalone

# Windows
cmd startup.cmd -m standalone
```

Nacos 控制台：http://localhost:8848/nacos
默认账号/密码：nacos/nacos

### 3. 在 Nacos 创建配置

登录 Nacos 控制台，进入 **配置管理 > 配置列表**，点击 **+** 创建配置：

- 命名空间：public（默认）
- Group：DEFAULT_GROUP
- Data ID：`sushepro-backend.yml`
- 配置格式：YAML

配置内容：

```yaml
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: sushepro-backend
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/susheguanli?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
    username: root
    password: 你的数据库密码
    druid:
      initial-size: 5
      min-idle: 5
      max-active: 20

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.sushepro.pojo
  configuration:
    map-underscore-to-camel-case: true

jwt:
  secret: your-secret-key-change-in-production-must-be-at-least-256-bits-long-for-hs256
  expiration: 86400000
```

### 4. 启动后端

```bash
cd sushepro-backend
mvn spring-boot:run
```

后端启动后会自动注册到 Nacos。

验证后端是否正常运行：
- 健康检查：http://localhost:8080/api/actuator/health
- Nacos 控制台服务列表应看到 `sushepro-backend`

### 5. 启动前端

```bash
cd sushepro-frontend
npm install
npm run dev
```

前端启动后访问：http://localhost:5173

## 账号说明

系统包含两类账号：

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | 657210abc | 管理员账号 |
| 学生 | student | 123456 | 学生账号 |

## API 文档

启动后端后可访问 Actuator 端点：
- http://localhost:8080/api/actuator

### 认证接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 登录 |
| POST | /api/auth/logout | 登出 |
| GET | /api/auth/me | 获取当前用户 |

### 学生端接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/student/index | 首页数据 |
| GET | /api/student/profile | 个人资料 |
| GET | /api/student/questionnaire | 问卷信息 |
| POST | /api/student/questionnaire | 提交问卷 |
| GET | /api/student/allocation | 宿舍分配 |
| GET | /api/student/transfers | 调换申请列表 |
| POST | /api/student/transfers | 提交调换申请 |
| GET | /api/student/repairs | 报修列表 |
| POST | /api/student/repairs | 提交报修 |

### 管理端接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/admin/index | 统计数据 |
| GET | /api/admin/students | 学生列表 |
| GET | /api/admin/dormitories | 宿舍列表 |
| POST | /api/admin/dormitories | 添加宿舍 |
| PUT | /api/admin/dormitories/{id} | 更新宿舍 |
| DELETE | /api/admin/dormitories/{id} | 删除宿舍 |
| GET | /api/admin/allocations | 分配列表 |
| POST | /api/admin/allocations | 分配宿舍 |
| GET | /api/admin/transfers | 调换列表 |
| PUT | /api/admin/transfers/{id}/approve | 通过调换 |
| PUT | /api/admin/transfers/{id}/reject | 拒绝调换 |
| GET | /api/admin/repairs | 报修列表 |
| PUT | /api/admin/repairs/{id}/process | 处理中 |
| PUT | /api/admin/repairs/{id}/complete | 完成报修 |
| POST | /api/admin/ai/recommend | AI推荐 |

### AI 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/ai/chat | AI客服聊天 |

## 原项目保留

原有 SSM 单体项目保留在 `src/` 目录，可在 Tomcat 中独立部署运行（端口 8080）。

## 常见问题

### 1. Nacos 连接失败

确保 Nacos 已启动且端口 8848 未被占用。

### 2. 数据库连接失败

检查 MySQL 是否运行，检查 `sushepro-backend.yml` 中的数据库账号密码是否正确。

### 3. 前端 API 请求失败

确保后端已启动（端口 8080），Vite 代理已正确配置。