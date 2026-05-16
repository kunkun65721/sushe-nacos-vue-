package com.sushepro.service;

/**
 * 文件内容提取服务接口
 */
public interface FileContentExtractor {

    /**
     * 从文件中提取文本内容
     * @param filePath 文件路径
     * @param fileType 文件类型
     * @return 提取的文本内容
     */
    String extractContent(String filePath, String fileType);

    /**
     * 检查是否支持该文件类型
     * @param fileType 文件类型
     * @return 是否支持
     */
    boolean isSupported(String fileType);
}