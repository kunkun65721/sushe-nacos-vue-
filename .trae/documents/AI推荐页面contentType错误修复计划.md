# 修复MySQL连接错误：Public Key Retrieval is not allowed

## 1. 问题描述

应用程序启动失败，错误信息为：`Public Key Retrieval is not allowed`，这是连接MySQL数据库时出现的认证错误。

## 2. 根本原因

MySQL 8.0默认使用`caching_sha2_password`认证插件，当客户端连接时需要获取服务器的公钥。当前配置文件中的JDBC URL缺少`allowPublicKeyRetrieval=true`参数，导致连接失败。

## 3. 修复方案

### 3.1 修改数据库连接URL

**文件路径**：`src/main/resources/db.properties`

**修改内容**：在JDBC URL中添加`allowPublicKeyRetrieval=true`参数

**修改前**：

```properties
jdbc.url=jdbc:mysql://localhost:3306/susheguanli?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false
```

**修改后**：

```properties
jdbc.url=jdbc:mysql://localhost:3306/susheguanli?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
```

### 3.2 验证修复结果

1. 保存修改后的配置文件
2. 重启Tomcat服务器
3. 检查应用日志，确认没有数据库连接错误
4. 验证应用正常启动

## 4. 预期效果

应用程序将成功启动，不再出现"Public Key Retrieval is not allowed"错误，数据库连接正常，所有功能可正常使用。

## 5. 注意事项

* 该修复方案适用于所有MySQL 8.0版本

* `allowPublicKeyRetrieval=true`参数允许客户端自动从服务器获取公钥

* 对于开发环境，这是安全的配置

* 生产环境中，建议考虑更安全的认证方式或网络配置

