-- ============================================
-- 宿舍管理系统 - 初始数据
-- ============================================

USE susheguanli;

-- 管理员账号
INSERT INTO user (username, password, role, status) VALUES ('admin', 'admin123', 1, 1);

-- 学生账号
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

-- 宿舍数据
INSERT INTO dormitory (dormitory_number, dormitory_type, capacity, current_occupancy, building, status) VALUES
('101', '4人间', 4, 0, '1号楼', 1),
('102', '4人间', 4, 0, '1号楼', 1),
('201', '6人间', 6, 0, '2号楼', 1),
('202', '6人间', 6, 0, '2号楼', 1),
('301', '4人间', 4, 0, '3号楼', 1),
('302', '4人间', 4, 0, '3号楼', 1),
('401', '6人间', 6, 0, '4号楼', 1),
('402', '6人间', 6, 0, '4号楼', 1);

-- 学生生活习惯问卷
INSERT INTO habit_questionnaire (student_id, sleep_time, wake_up_time, smoking, drinking, noise_tolerance, cleanliness, note) VALUES
(1, '23:00', '07:00', 0, 0, 4, 3, '喜欢安静，早睡早起'),
(2, '00:00', '08:00', 0, 1, 3, 2, '偶尔熬夜，喜欢听歌'),
(3, '22:30', '06:30', 0, 0, 5, 5, '非常注重个人卫生，作息规律'),
(4, '23:30', '07:30', 0, 0, 2, 4, '对噪音敏感，要求宿舍整洁'),
(5, '24:00', '09:00', 1, 1, 5, 1, '喜欢熬夜，不拘小节'),
(6, '22:00', '06:00', 0, 0, 4, 4, '早睡早起，喜欢运动');

-- 宿舍分配记录
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