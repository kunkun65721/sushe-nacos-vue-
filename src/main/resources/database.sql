-- ============================================
-- 宿舍管理系统 - 数据库初始化脚本
-- ============================================

CREATE DATABASE IF NOT EXISTS susheguanli DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE susheguanli;

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 用户表
-- ============================================
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role INT NOT NULL COMMENT '0：学生，1：管理员',
    status INT NOT NULL DEFAULT 1 COMMENT '0：禁用，1：启用',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 学生信息表
-- ============================================
DROP TABLE IF EXISTS student;
CREATE TABLE student (
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

-- ============================================
-- 宿舍表
-- ============================================
DROP TABLE IF EXISTS dormitory;
CREATE TABLE dormitory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dormitory_number VARCHAR(20) NOT NULL UNIQUE,
    dormitory_type VARCHAR(20) NOT NULL COMMENT '如：4人间，6人间',
    capacity INT NOT NULL COMMENT '容纳人数',
    current_occupancy INT NOT NULL DEFAULT 0 COMMENT '当前入住人数',
    building VARCHAR(20) NOT NULL COMMENT '楼栋',
    status INT NOT NULL DEFAULT 1 COMMENT '0：禁用，1：启用'
);

-- ============================================
-- 生活习惯问卷表
-- ============================================
DROP TABLE IF EXISTS habit_questionnaire;
CREATE TABLE habit_questionnaire (
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

-- ============================================
-- 宿舍分配表
-- ============================================
DROP TABLE IF EXISTS dormitory_allocation;
CREATE TABLE dormitory_allocation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    dormitory_id INT NOT NULL,
    allocate_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status INT NOT NULL DEFAULT 0 COMMENT '0：已分配，1：已入住，2：已搬出',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (dormitory_id) REFERENCES dormitory(id) ON DELETE CASCADE
);

-- ============================================
-- 宿舍调换申请表
-- ============================================
DROP TABLE IF EXISTS dormitory_transfer;
CREATE TABLE dormitory_transfer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL COMMENT '申请人学生ID',
    current_dormitory_id INT NOT NULL COMMENT '当前宿舍ID',
    target_dormitory_id INT COMMENT '意向目标宿舍ID（可选）',
    reason VARCHAR(500) NOT NULL COMMENT '申请理由',
    attachment VARCHAR(500) COMMENT '附件路径（证明材料等）',
    status INT NOT NULL DEFAULT 0 COMMENT '0=待审核，1=已通过，2=已拒绝',
    admin_comment VARCHAR(500) COMMENT '管理员审批意见',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    review_time DATETIME COMMENT '审核时间',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (current_dormitory_id) REFERENCES dormitory(id) ON DELETE CASCADE,
    FOREIGN KEY (target_dormitory_id) REFERENCES dormitory(id) ON DELETE SET NULL
);

-- ============================================
-- 报修申请表
-- ============================================
DROP TABLE IF EXISTS repair_request;
CREATE TABLE repair_request (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    dormitory_id INT,
    description TEXT NOT NULL,
    image VARCHAR(500),
    status INT NOT NULL DEFAULT 0 COMMENT '0=待处理，1=处理中，2=已完成，3=已拒绝',
    admin_comment TEXT,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (dormitory_id) REFERENCES dormitory(id) ON DELETE SET NULL
);

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 初始数据
-- ============================================

-- 管理员
INSERT INTO user (username, password, role, status) VALUES ('admin', 'admin123', 1, 1);

-- 学生用户
INSERT INTO user (username, password, role, status) VALUES
('student1', 'student123', 0, 1),
('student2', 'student123', 0, 1),
('student3', 'student123', 0, 1),
('student4', 'student123', 0, 1),
('student5', 'student123', 0, 1),
('student6', 'student123', 0, 1);

-- 学生信息
INSERT INTO student (user_id, name, gender, major, grade, student_id, phone) VALUES
(2, '张三', 0, '计算机科学与技术', '2021级', '20210001', '13800138001'),
(3, '李四', 0, '计算机科学与技术', '2021级', '20210002', '13800138002'),
(4, '王五', 0, '软件工程', '2021级', '20210003', '13800138003'),
(5, '赵六', 1, '数据科学与大数据技术', '2021级', '20210004', '13800138004'),
(6, '钱七', 1, '人工智能', '2021级', '20210005', '13800138005'),
(7, '孙八', 0, '网络工程', '2021级', '20210006', '13800138006');

-- 宿舍
INSERT INTO dormitory (dormitory_number, dormitory_type, capacity, current_occupancy, building, status) VALUES
('101', '4人间', 4, 0, '1号楼', 1),
('102', '4人间', 4, 0, '1号楼', 1),
('201', '6人间', 6, 0, '2号楼', 1),
('202', '6人间', 6, 0, '2号楼', 1),
('301', '4人间', 4, 0, '3号楼', 1),
('302', '4人间', 4, 0, '3号楼', 1),
('401', '6人间', 6, 0, '4号楼', 1),
('402', '6人间', 6, 0, '4号楼', 1);

-- 生活习惯问卷
INSERT INTO habit_questionnaire (student_id, sleep_time, wake_up_time, smoking, drinking, noise_tolerance, cleanliness, note) VALUES
(1, '23:00', '07:00', 0, 0, 4, 3, '喜欢安静，早睡早起'),
(2, '00:00', '08:00', 0, 1, 3, 2, '偶尔熬夜，喜欢听歌'),
(3, '22:30', '06:30', 0, 0, 5, 5, '非常注重个人卫生，作息规律'),
(4, '23:30', '07:30', 0, 0, 2, 4, '对噪音敏感，要求宿舍整洁'),
(5, '24:00', '09:00', 1, 1, 5, 1, '喜欢熬夜，不拘小节'),
(6, '22:00', '06:00', 0, 0, 4, 4, '早睡早起，喜欢运动');

-- 宿舍分配
INSERT INTO dormitory_allocation (student_id, dormitory_id, allocate_time, status) VALUES
(1, 1, NOW(), 1),
(2, 1, NOW(), 1),
(3, 2, NOW(), 1),
(4, 3, NOW(), 0),
(5, 3, NOW(), 1),
(6, 4, NOW(), 0);

-- 更新宿舍当前入住人数
UPDATE dormitory SET current_occupancy = (SELECT COUNT(*) FROM dormitory_allocation WHERE dormitory_id = 1 AND status = 1) WHERE id = 1;
UPDATE dormitory SET current_occupancy = (SELECT COUNT(*) FROM dormitory_allocation WHERE dormitory_id = 2 AND status = 1) WHERE id = 2;
UPDATE dormitory SET current_occupancy = (SELECT COUNT(*) FROM dormitory_allocation WHERE dormitory_id = 3 AND status = 1) WHERE id = 3;
UPDATE dormitory SET current_occupancy = (SELECT COUNT(*) FROM dormitory_allocation WHERE dormitory_id = 4 AND status = 1) WHERE id = 4;
