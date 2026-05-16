package com.sushepro.service.impl;

import com.sushepro.service.FileContentExtractor;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.TextPosition;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashSet;
import java.util.Set;

@Service
public class FileContentExtractorImpl implements FileContentExtractor {

    private static final Set<String> SUPPORTED_TYPES = new HashSet<>();
    static {
        SUPPORTED_TYPES.add("pdf");
        SUPPORTED_TYPES.add("doc");
        SUPPORTED_TYPES.add("docx");
        SUPPORTED_TYPES.add("xls");
        SUPPORTED_TYPES.add("xlsx");
        SUPPORTED_TYPES.add("txt");
    }

    @Override
    public String extractContent(String filePath, String fileType) {
        if (!isSupported(fileType)) {
            return "";
        }

        try {
            return switch (fileType.toLowerCase()) {
                case "pdf" -> extractFromPdf(filePath);
                case "doc", "docx" -> extractFromWord(filePath, fileType);
                case "xls", "xlsx" -> extractFromExcel(filePath, fileType);
                case "txt" -> extractFromTxt(filePath);
                default -> "";
            };
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    @Override
    public boolean isSupported(String fileType) {
        return SUPPORTED_TYPES.contains(fileType.toLowerCase());
    }

    private String extractFromPdf(String filePath) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            return "";
        }

        try (PDDocument document = Loader.loadPDF(file)) {
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        }
    }

    private String extractFromWord(String filePath, String fileType) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            return "";
        }

        StringBuilder content = new StringBuilder();

        try (FileInputStream fis = new FileInputStream(file)) {
            if ("docx".equalsIgnoreCase(fileType)) {
                try (XWPFDocument document = new XWPFDocument(fis)) {
                    for (XWPFParagraph paragraph : document.getParagraphs()) {
                        if (content.length() > 0) {
                            content.append("\n");
                        }
                        content.append(paragraph.getText());
                    }
                }
            } else {
                try (HSSFWorkbook workbook = new HSSFWorkbook(fis)) {
                    HSSFSheet sheet = workbook.getSheetAt(0);
                    for (Row row : sheet) {
                        for (Cell cell : row) {
                            if (content.length() > 0) {
                                content.append(" ");
                            }
                            content.append(getCellText(cell));
                        }
                        content.append("\n");
                    }
                }
            }
        }

        return content.toString();
    }

    private String extractFromExcel(String filePath, String fileType) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            return "";
        }

        StringBuilder content = new StringBuilder();

        try (FileInputStream fis = new FileInputStream(file)) {
            if ("xlsx".equalsIgnoreCase(fileType)) {
                try (XSSFWorkbook workbook = new XSSFWorkbook(fis)) {
                    XSSFSheet sheet = workbook.getSheetAt(0);
                    for (Row row : sheet) {
                        for (Cell cell : row) {
                            if (content.length() > 0) {
                                content.append(" ");
                            }
                            content.append(getCellText(cell));
                        }
                        content.append("\n");
                    }
                }
            } else {
                try (HSSFWorkbook workbook = new HSSFWorkbook(fis)) {
                    HSSFSheet sheet = workbook.getSheetAt(0);
                    for (Row row : sheet) {
                        for (Cell cell : row) {
                            if (content.length() > 0) {
                                content.append(" ");
                            }
                            content.append(getCellText(cell));
                        }
                        content.append("\n");
                    }
                }
            }
        }

        return content.toString();
    }

    private String extractFromTxt(String filePath) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            return "";
        }
        // 使用 UTF-8 编码读取，如果失败则尝试 GBK 编码
        try {
            return Files.readString(file.toPath(), java.nio.charset.StandardCharsets.UTF_8);
        } catch (Exception e) {
            // 尝试 GBK 编码（兼容中文 Windows 系统）
            return Files.readString(file.toPath(), java.nio.charset.Charset.forName("GBK"));
        }
    }

    private String getCellText(Cell cell) {
        if (cell == null) {
            return "";
        }
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> String.valueOf(cell.getNumericCellValue());
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            case FORMULA -> cell.getCellFormula();
            default -> "";
        };
    }
}