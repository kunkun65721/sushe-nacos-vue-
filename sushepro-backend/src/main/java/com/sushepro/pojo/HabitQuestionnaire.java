package com.sushepro.pojo;

import java.util.Date;

public class HabitQuestionnaire {
    private Integer id;
    private Integer studentId;
    private String sleepTime;
    private String wakeUpTime;
    private Integer smoking; // 0：否，1：是
    private Integer drinking; // 0：否，1：是
    private Integer noiseTolerance; // 噪音容忍度（1-5）
    private Integer cleanliness; // 清洁要求（1-5）
    private String note;
    private Date createTime;
    private String studentName;

    // getter and setter methods
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

    public String getSleepTime() {
        return sleepTime;
    }

    public void setSleepTime(String sleepTime) {
        this.sleepTime = sleepTime;
    }

    public String getWakeUpTime() {
        return wakeUpTime;
    }

    public void setWakeUpTime(String wakeUpTime) {
        this.wakeUpTime = wakeUpTime;
    }

    public Integer getSmoking() {
        return smoking;
    }

    public void setSmoking(Integer smoking) {
        this.smoking = smoking;
    }

    public Integer getDrinking() {
        return drinking;
    }

    public void setDrinking(Integer drinking) {
        this.drinking = drinking;
    }

    public Integer getNoiseTolerance() {
        return noiseTolerance;
    }

    public void setNoiseTolerance(Integer noiseTolerance) {
        this.noiseTolerance = noiseTolerance;
    }

    public Integer getCleanliness() {
        return cleanliness;
    }

    public void setCleanliness(Integer cleanliness) {
        this.cleanliness = cleanliness;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
}