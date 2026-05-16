package com.sushepro.service;

import com.sushepro.pojo.KnowledgeBase;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface KnowledgeBaseService {

    /**
     * 上传知识库文档
     * @param file 上传的文件
     * @param title 文档标题
     * @param category 分类
     * @return 上传结果
     */
    Map<String, Object> uploadDocument(MultipartFile file, String title, String category);

    /**
     * 获取知识库列表
     * @param category 分类筛选
     * @param status 状态筛选
     * @param page 页码
     * @param size 每页数量
     * @return 知识库列表
     */
    List<KnowledgeBase> getDocumentList(String category, Integer status, int page, int size);

    /**
     * 获取知识库总数
     * @param category 分类筛选
     * @param status 状态筛选
     * @return 总数
     */
    int getDocumentCount(String category, Integer status);

    /**
     * 获取文档详情
     * @param id 文档ID
     * @return 文档信息
     */
    KnowledgeBase getDocumentById(Integer id);

    /**
     * 删除文档
     * @param id 文档ID
     * @return 是否成功
     */
    boolean deleteDocument(Integer id);

    /**
     * 更新文档状态
     * @param id 文档ID
     * @param status 新状态
     * @return 是否成功
     */
    boolean updateStatus(Integer id, Integer status);

    /**
     * 获取所有启用的知识库内容（供AI使用）
     * @return 所有启用文档的文本内容
     */
    String getAllEnabledContentForAI();
}