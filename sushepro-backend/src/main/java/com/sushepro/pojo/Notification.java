package com.sushepro.pojo;

import java.util.Date;

public class Notification {
    private Integer id;
    private Integer userId;
    private String type;
    private Integer referenceId;
    private String referenceType;
    private String title;
    private String content;
    private Integer refStatus;
    private Integer relatedStudentId;
    private String relatedStudentName;
    private Integer isRead;
    private Integer isDeleted;
    private Date createTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(String referenceType) {
        this.referenceType = referenceType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getRefStatus() {
        return refStatus;
    }

    public void setRefStatus(Integer refStatus) {
        this.refStatus = refStatus;
    }

    public Integer getRelatedStudentId() {
        return relatedStudentId;
    }

    public void setRelatedStudentId(Integer relatedStudentId) {
        this.relatedStudentId = relatedStudentId;
    }

    public String getRelatedStudentName() {
        return relatedStudentName;
    }

    public void setRelatedStudentName(String relatedStudentName) {
        this.relatedStudentName = relatedStudentName;
    }

    public Integer getIsRead() {
        return isRead;
    }

    public void setIsRead(Integer isRead) {
        this.isRead = isRead;
    }

    public Integer getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Integer isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
