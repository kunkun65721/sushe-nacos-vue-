-- ============================================
-- 知识库表创建脚本
-- ============================================

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