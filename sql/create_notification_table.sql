-- ============================================
-- 通知表 - 独立的通知系统
-- 删除通知仅软删除此表记录，不影响业务数据
-- ============================================

CREATE TABLE IF NOT EXISTS notification (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '通知主键ID',
    user_id INT NOT NULL COMMENT '接收通知的用户ID（对应user表）',
    type VARCHAR(50) NOT NULL COMMENT '通知子类型: repair_submitted/repair_processing/repair_completed/repair_rejected/transfer_submitted/transfer_approved/transfer_rejected/allocation_created',
    reference_id INT NOT NULL COMMENT '关联的业务记录ID（repair_request/dormitory_transfer/dormitory_allocation）',
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
