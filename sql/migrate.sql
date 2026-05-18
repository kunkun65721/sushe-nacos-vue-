-- ============================================
-- 宿舍管理系统 - 数据迁移脚本
-- 将现有业务记录回填为通知
-- is_read = 1 所以旧数据不会触发未读计数
-- ============================================

USE susheguanli;

-- === 1. 学生报修通知 ===
INSERT INTO notification (user_id, type, reference_id, reference_type, title, content, ref_status, related_student_id, related_student_name, is_read, create_time)
SELECT
    u.id,
    CASE r.status
        WHEN 0 THEN 'repair_submitted'
        WHEN 1 THEN 'repair_processing'
        WHEN 2 THEN 'repair_completed'
        WHEN 3 THEN 'repair_rejected'
    END,
    r.id,
    'repair',
    CASE r.status
        WHEN 0 THEN '报修申请已提交'
        WHEN 1 THEN '报修正在处理中'
        WHEN 2 THEN '报修已完成'
        WHEN 3 THEN '报修已被拒绝'
    END,
    CONCAT(IFNULL(d.building, ''), IFNULL(d.dormitory_number, ''), ' - ', r.description),
    r.status,
    s.id,
    s.name,
    1,
    r.create_time
FROM repair_request r
JOIN student s ON r.student_id = s.id
JOIN user u ON s.user_id = u.id
LEFT JOIN dormitory d ON r.dormitory_id = d.id;

-- === 2. 管理员报修通知（仅待处理） ===
INSERT INTO notification (user_id, type, reference_id, reference_type, title, content, ref_status, related_student_id, related_student_name, is_read, create_time)
SELECT
    a.id,
    'repair_submitted',
    r.id,
    'repair',
    '新的报修申请',
    CONCAT(IFNULL(d.building, ''), IFNULL(d.dormitory_number, ''), ' - ', r.description),
    r.status,
    s.id,
    s.name,
    1,
    r.create_time
FROM repair_request r
JOIN student s ON r.student_id = s.id
JOIN user a ON a.role = 1
LEFT JOIN dormitory d ON r.dormitory_id = d.id
WHERE r.status = 0;

-- === 3. 学生调换通知 ===
INSERT INTO notification (user_id, type, reference_id, reference_type, title, content, ref_status, related_student_id, related_student_name, is_read, create_time)
SELECT
    u.id,
    CASE t.status
        WHEN 0 THEN 'transfer_submitted'
        WHEN 1 THEN 'transfer_approved'
        WHEN 2 THEN 'transfer_rejected'
    END,
    t.id,
    'transfer',
    CASE t.status
        WHEN 0 THEN '调换申请已提交'
        WHEN 1 THEN '调换申请已通过'
        WHEN 2 THEN '调换申请已被拒绝'
    END,
    t.reason,
    t.status,
    s.id,
    s.name,
    1,
    t.apply_time
FROM dormitory_transfer t
JOIN student s ON t.student_id = s.id
JOIN user u ON s.user_id = u.id;

-- === 4. 管理员调换通知（仅待审核） ===
INSERT INTO notification (user_id, type, reference_id, reference_type, title, content, ref_status, related_student_id, related_student_name, is_read, create_time)
SELECT
    a.id,
    'transfer_submitted',
    t.id,
    'transfer',
    '新的调换申请',
    CONCAT(s.name, ' 申请调换宿舍'),
    t.status,
    s.id,
    s.name,
    1,
    t.apply_time
FROM dormitory_transfer t
JOIN student s ON t.student_id = s.id
JOIN user a ON a.role = 1
WHERE t.status = 0;

-- === 5. 宿舍分配通知 ===
INSERT INTO notification (user_id, type, reference_id, reference_type, title, content, ref_status, is_read, create_time)
SELECT
    u.id,
    'allocation_created',
    a.id,
    'allocation',
    '宿舍分配完成',
    CONCAT(IFNULL(d.building, ''), IFNULL(d.dormitory_number, '')),
    a.status,
    1,
    a.allocate_time
FROM dormitory_allocation a
JOIN student s ON a.student_id = s.id
JOIN user u ON s.user_id = u.id
LEFT JOIN dormitory d ON a.dormitory_id = d.id;