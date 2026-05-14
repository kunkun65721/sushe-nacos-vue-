package com.sushepro.pojo;

import java.util.Date;

public class DormitoryTransfer {
    private Integer id;
    private Integer studentId;
    private Integer currentDormitoryId;
    private Integer targetDormitoryId;
    private String reason;
    private String attachment;
    private Integer status; // 0：待审核，1：已通过，2：已拒绝
    private String adminComment;
    private Date applyTime;
    private Date reviewTime;

    // JOIN 展示字段
    private String studentName;
    private String studentNumber;
    private String currentDormitoryNumber;
    private String currentBuilding;
    private String targetDormitoryNumber;
    private String targetBuilding;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public Integer getCurrentDormitoryId() {
        return currentDormitoryId;
    }

    public void setCurrentDormitoryId(Integer currentDormitoryId) {
        this.currentDormitoryId = currentDormitoryId;
    }

    public Integer getTargetDormitoryId() {
        return targetDormitoryId;
    }

    public void setTargetDormitoryId(Integer targetDormitoryId) {
        this.targetDormitoryId = targetDormitoryId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getAttachment() {
        return attachment;
    }

    public void setAttachment(String attachment) {
        this.attachment = attachment;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getAdminComment() {
        return adminComment;
    }

    public void setAdminComment(String adminComment) {
        this.adminComment = adminComment;
    }

    public Date getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(Date applyTime) {
        this.applyTime = applyTime;
    }

    public Date getReviewTime() {
        return reviewTime;
    }

    public void setReviewTime(Date reviewTime) {
        this.reviewTime = reviewTime;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentNumber() {
        return studentNumber;
    }

    public void setStudentNumber(String studentNumber) {
        this.studentNumber = studentNumber;
    }

    public String getCurrentDormitoryNumber() {
        return currentDormitoryNumber;
    }

    public void setCurrentDormitoryNumber(String currentDormitoryNumber) {
        this.currentDormitoryNumber = currentDormitoryNumber;
    }

    public String getCurrentBuilding() {
        return currentBuilding;
    }

    public void setCurrentBuilding(String currentBuilding) {
        this.currentBuilding = currentBuilding;
    }

    public String getTargetDormitoryNumber() {
        return targetDormitoryNumber;
    }

    public void setTargetDormitoryNumber(String targetDormitoryNumber) {
        this.targetDormitoryNumber = targetDormitoryNumber;
    }

    public String getTargetBuilding() {
        return targetBuilding;
    }

    public void setTargetBuilding(String targetBuilding) {
        this.targetBuilding = targetBuilding;
    }
}
