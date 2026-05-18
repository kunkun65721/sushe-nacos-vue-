-- ============================================
-- 宿舍管理系统 - 重置数据库脚本
-- 警告：此脚本会清空所有表数据！
-- ============================================

USE susheguanli;

-- 禁用外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- 清空所有表数据（注意顺序，先删除有外键依赖的表）
TRUNCATE TABLE dormitory_allocation;
TRUNCATE TABLE habit_questionnaire;
TRUNCATE TABLE student;
TRUNCATE TABLE dormitory;
TRUNCATE TABLE user;

-- 启用外键检查
SET FOREIGN_KEY_CHECKS = 1;