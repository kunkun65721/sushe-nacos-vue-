# 宿舍管理系统

基于 SSM 单体应用改造的轻量级分布式架构，采用前后端分离设计。

## 技术栈

### 后端
- **Spring Boot 3.2.5** + **MyBatis 3.0.3**
- **Nacos**（注册中心 + 配置中心）
- **JWT**（认证）+ **Druid**（连接池）

### 前端
- **Vue 3.4** + **Element Plus 2.6**
- **Vite 5.2** + **Pinia**（状态管理）

## 一键启动

双击运行 `start.bat`，自动启动后端和前端：

```
sushepro-backend  → http://localhost:8080
sushepro-frontend  → http://localhost:5173
```

## 手动启动

### 环境要求
- JDK 21+ / Node.js 18+ / Maven 3.8+
- MySQL 8.0+ / Nacos 2.x

### 1. 启动 Nacos

```bash
# Windows
cmd startup.cmd -m standalone

# Linux/Mac
sh startup.sh -m standalone
```

访问 http://localhost:8848/nacos（账号：nacos/nacos）

### 2. Nacos 配置

在 Nacos 控制台创建配置（Group: DEFAULT_GROUP，Data ID: `sushepro-backend.yml`）：

```yaml
servlet:
  multipart:
    enabled: true
    max-file-size: 10MB
    max-request-size: 10MB

datasource:
  type: com.alibaba.druid.pool.DruidDataSource
  driver-class-name: com.mysql.cj.jdbc.Driver
  url: jdbc:mysql://localhost:3306/susheguanli?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
  username: root
  password: 你的数据库密码

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.sushepro.pojo
  configuration:
    map-underscore-to-camel-case: true

jwt:
  secret: your-secret-key-change-in-production-must-be-at-least-256-bits-long-for-hs256
  expiration: 86400000
```

### 3. 启动后端

```bash
cd sushepro-backend
mvn spring-boot:run
```

### 4. 启动前端

```bash
cd sushepro-frontend
npm install
npm run dev
```

## 账号说明

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | 657210abc | 管理员账号 |
| 学生 | student | 123456 | 学生账号 |

## API 概览

### 认证
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 登录 |
| POST | /api/auth/logout | 登出 |
| GET | /api/auth/me | 获取当前用户 |

### 学生端
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/student/index | 首页数据 |
| GET | /api/student/profile | 个人资料 |
| POST | /api/student/questionnaire | 提交问卷 |
| GET | /api/student/allocation | 宿舍分配 |
| POST | /api/student/transfers | 调换申请 |
| POST | /api/student/repairs | 报修申请 |

### 管理端
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/admin/index | 统计数据 |
| GET | /api/admin/students | 学生列表 |
| CRUD | /api/admin/dormitories | 宿舍管理 |
| CRUD | /api/admin/allocations | 分配管理 |
| PUT | /api/admin/transfers/{id}/approve | 通过调换 |
| PUT | /api/admin/repairs/{id}/process | 处理报修 |
| POST | /api/admin/ai/recommend | AI推荐 |

## 项目结构

```
sushepro/
├── start.bat                    # 一键启动脚本
├── sushepro-backend/             # 后端服务 (Spring Boot)
│   ├── src/main/java/com/sushepro/
│   │   ├── controller/          # REST API控制器
│   │   ├── service/             # 业务逻辑
│   │   ├── mapper/              # 数据访问
│   │   ├── pojo/                # 实体类
│   │   └── dto/                 # 数据传输对象
│   ├── src/main/resources/
│   │   ├── application.yml      # 本地配置 (fallback)
│   │   ├── bootstrap.yml        # Nacos配置引导
│   │   └── mapper/              # MyBatis映射文件
│   └── nacos-config/            # Nacos配置模板
├── sushepro-frontend/           # 前端应用 (Vue 3)
│   ├── src/
│   │   ├── api/                 # API调用层
│   │   ├── views/               # 页面组件
│   │   ├── router/              # 路由配置
│   │   └── stores/              # 状态管理
│   └── package.json
└── sql/                         # SQL脚本
```

## 常见问题

**Nacos 连接失败** - 确保 Nacos 已启动，端口 8848 未被占用

**数据库连接失败** - 检查 MySQL 是否运行，配置中的账号密码是否正确

**前端请求失败** - 确保后端已启动（端口 8080），Vite 代理已配置