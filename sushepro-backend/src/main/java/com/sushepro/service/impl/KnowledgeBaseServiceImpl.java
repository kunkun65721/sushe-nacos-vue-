package com.sushepro.service.impl;

import com.sushepro.mapper.KnowledgeBaseMapper;
import com.sushepro.pojo.KnowledgeBase;
import com.sushepro.service.FileContentExtractor;
import com.sushepro.service.KnowledgeBaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class KnowledgeBaseServiceImpl implements KnowledgeBaseService {

    @Autowired
    private KnowledgeBaseMapper knowledgeBaseMapper;

    @Autowired
    private FileContentExtractor fileContentExtractor;

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

    @Override
    public Map<String, Object> uploadDocument(MultipartFile file, String title, String category) {
        Map<String, Object> result = new HashMap<>();

        if (file.isEmpty()) {
            result.put("success", false);
            result.put("message", "文件不能为空");
            return result;
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            result.put("success", false);
            result.put("message", "文件大小不能超过10MB");
            return result;
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.contains(".")) {
            result.put("success", false);
            result.put("message", "无法识别文件类型");
            return result;
        }

        String fileType = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();

        if (!fileContentExtractor.isSupported(fileType)) {
            result.put("success", false);
            result.put("message", "不支持的文件类型，仅支持：pdf、doc、docx、xls、xlsx、txt");
            return result;
        }

        try {
            // 保存文件
            // user.dir 默认是后端模块目录，需要回退两级到项目根目录
            String projectRoot = new File(System.getProperty("user.dir")).getParent();
            String uploadDir = projectRoot + File.separator + "uploads" + File.separator + "knowledge";
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String savedFileName = UUID.randomUUID().toString() + "." + fileType;
            String filePath = uploadDir + File.separator + savedFileName;
            file.transferTo(new File(filePath));

            // 提取文本内容
            String contentSummary = fileContentExtractor.extractContent(filePath, fileType);

            // 如果没有设置标题，使用原文件名
            if (title == null || title.trim().isEmpty()) {
                title = originalFilename.substring(0, originalFilename.lastIndexOf("."));
            }

            // 保存到数据库
            KnowledgeBase kb = new KnowledgeBase();
            kb.setTitle(title);
            kb.setFileName(originalFilename);
            kb.setFilePath(filePath);
            kb.setFileType(fileType);
            kb.setFileSize(file.getSize());
            kb.setContentSummary(contentSummary);
            kb.setStatus(1); // 默认启用
            kb.setCategory(category != null ? category : "general");
            kb.setVisitCount(0);

            knowledgeBaseMapper.insert(kb);

            result.put("success", true);
            result.put("message", "上传成功");
            result.put("data", kb);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "上传失败: " + e.getMessage());
        }

        return result;
    }

    @Override
    public List<KnowledgeBase> getDocumentList(String category, Integer status, int page, int size) {
        int offset = (page - 1) * size;
        return knowledgeBaseMapper.findList(category, status, offset, size);
    }

    @Override
    public int getDocumentCount(String category, Integer status) {
        return knowledgeBaseMapper.count(category, status);
    }

    @Override
    public KnowledgeBase getDocumentById(Integer id) {
        KnowledgeBase kb = knowledgeBaseMapper.findById(id);
        if (kb != null) {
            knowledgeBaseMapper.incrementVisitCount(id);
        }
        return kb;
    }

    @Override
    public boolean deleteDocument(Integer id) {
        KnowledgeBase kb = knowledgeBaseMapper.findById(id);
        if (kb == null) {
            return false;
        }

        // 删除文件
        File file = new File(kb.getFilePath());
        if (file.exists()) {
            file.delete();
        }

        // 删除数据库记录
        knowledgeBaseMapper.deleteById(id);
        return true;
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        return knowledgeBaseMapper.updateStatus(id, status) > 0;
    }

    @Override
    public String getAllEnabledContentForAI() {
        List<KnowledgeBase> list = knowledgeBaseMapper.findAllEnabled();
        if (list == null || list.isEmpty()) {
            return "";
        }

        StringBuilder content = new StringBuilder();
        for (KnowledgeBase kb : list) {
            content.append("【").append(kb.getTitle()).append("】\n");
            if (kb.getContentSummary() != null && !kb.getContentSummary().isEmpty()) {
                content.append(kb.getContentSummary());
            }
            content.append("\n\n");
        }

        return content.toString();
    }
}