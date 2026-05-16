package com.sushepro.mapper;

import com.sushepro.pojo.KnowledgeBase;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface KnowledgeBaseMapper {
    // 根据ID查询
    KnowledgeBase findById(Integer id);

    // 查询所有启用的知识库
    List<KnowledgeBase> findAllEnabled();

    // 分页查询列表
    List<KnowledgeBase> findList(@Param("category") String category,
                                @Param("status") Integer status,
                                @Param("offset") int offset,
                                @Param("limit") int limit);

    // 统计数量
    int count(@Param("category") String category, @Param("status") Integer status);

    // 添加知识库
    int insert(KnowledgeBase kb);

    // 更新知识库
    int update(KnowledgeBase kb);

    // 删除知识库
    int deleteById(Integer id);

    // 更新状态
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    // 更新访问次数
    int incrementVisitCount(Integer id);
}