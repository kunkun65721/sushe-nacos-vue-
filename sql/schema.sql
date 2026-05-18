-- ============================================
-- 宿舍管理系统 - 建表语句
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS susheguanli DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE susheguanli;

-- 创建用户表
CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role INT NOT NULL COMMENT '0：学生，1：管理员',
    status INT NOT NULL DEFAULT 1 COMMENT '0：禁用，1：启用',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 创建学生信息表
CREATE TABLE IF NOT EXISTS student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    gender INT NOT NULL COMMENT '0：男，1：女',
    major VARCHAR(100) NOT NULL,
    grade VARCHAR(20) NOT NULL,
    student_id VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

-- 创建宿舍表
CREATE TABLE IF NOT EXISTS dormitory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dormitory_number VARCHAR(20) NOT NULL UNIQUE,
    dormitory_type VARCHAR(20) NOT NULL COMMENT '如：4人间，6人间',
    capacity INT NOT NULL COMMENT '容纳人数',
    current_occupancy INT NOT NULL DEFAULT 0 COMMENT '当前入住人数',
    building VARCHAR(20) NOT NULL COMMENT '楼栋',
    status INT NOT NULL DEFAULT 1 COMMENT '0：禁用，1：启用'
);

-- 创建生活习惯问卷表
CREATE TABLE IF NOT EXISTS habit_questionnaire (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    sleep_time VARCHAR(20) NOT NULL COMMENT '睡眠时间',
    wake_up_time VARCHAR(20) NOT NULL COMMENT '起床时间',
    smoking INT NOT NULL COMMENT '0：否，1：是',
    drinking INT NOT NULL COMMENT '0：否，1：是',
    noise_tolerance INT NOT NULL COMMENT '噪音容忍度（1-5）',
    cleanliness INT NOT NULL COMMENT '清洁要求（1-5）',
    note VARCHAR(500) COMMENT '其他备注',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);

-- 创建宿舍分配表
CREATE TABLE IF NOT EXISTS dormitory_allocation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    dormitory_id INT NOT NULL,
    allocate_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status INT NOT NULL DEFAULT 0 COMMENT '0：已分配，1：已入住，2：已搬出',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (dormitory_id) REFERENCES dormitory(id) ON DELETE CASCADE
);

-- 创建知识库表
CREATE TABLE IF NOT EXISTS knowledge_base (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    title VARCHAR(255) NOT NULL COMMENT '文档标题',
    file_name VARCHAR(500) NOT NULL COMMENT '原始文件名',
    file_path VARCHAR(1000) NOT NULL COMMENT '文件存储路径',
    file_type VARCHAR(50) NOT NULL COMMENT '文件类型 (pdf/word/excel/txt)',
    file_size BIGINT COMMENT '文件大小(字节)',
    content_summary LONGTEXT COMMENT '提取的文本内容',
    status TINYINT DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
    category VARCHAR(100) DEFAULT 'general' COMMENT '分类: general/rules/faq/repair',
    visit_count INT DEFAULT 0 COMMENT '访问次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_create_time (create_time)
) COMMENT='知识库文档表';

-- 创建通知表
CREATE TABLE IF NOT EXISTS notification (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '通知主键ID',
    user_id INT NOT NULL COMMENT '接收通知的用户ID（对应user表）',
    type VARCHAR(50) NOT NULL COMMENT '通知子类型: repair_submitted/repair_processing/repair_completed/repair_rejected/transfer_submitted/transfer_approved/transfer_rejected/allocation_created',
    reference_id INT NOT NULL COMMENT '关联的业务记录ID',
    reference_type VARCHAR(20) NOT NULL COMMENT '关联业务类型: repair/transfer/allocation',
    title VARCHAR(255) NOT NULL COMMENT '通知标题',
    content TEXT COMMENT '通知内容/描述',
    ref_status INT COMMENT '业务记录在生成时的状态快照',
    related_student_id INT COMMENT '相关学生ID（admin通知需要）',
    related_student_name VARCHAR(100) COMMENT '相关学生姓名（反范式化，免JOIN）',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读: 0=未读, 1=已读',
    is_deleted TINYINT DEFAULT 0 COMMENT '是否删除(隐藏): 0=正常, 1=已删除',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user_id (user_id),
    INDEX idx_user_active (user_id, is_deleted, is_read),
    INDEX idx_reference (reference_type, reference_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';