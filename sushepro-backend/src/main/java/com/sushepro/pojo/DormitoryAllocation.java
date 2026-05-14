package com.sushepro.pojo;

import java.util.Date;

public class DormitoryAllocation {
    private Integer id;
    private Integer studentId;
    private Integer dormitoryId;
    private Date allocateTime;
    private Integer status; // 0：已分配，1：已入住，2：已搬出
    
    // 宿舍相关属性
    private String dormitoryNumber;
    private String dormitoryType;
    private String building;
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

    public Integer getDormitoryId() {
        return dormitoryId;
    }

    public void setDormitoryId(Integer dormitoryId) {
        this.dormitoryId = dormitoryId;
    }

    public Date getAllocateTime() {
        return allocateTime;
    }

    public void setAllocateTime(Date allocateTime) {
        this.allocateTime = allocateTime;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getDormitoryNumber() {
        return dormitoryNumber;
    }

    public void setDormitoryNumber(String dormitoryNumber) {
        this.dormitoryNumber = dormitoryNumber;
    }

    public String getDormitoryType() {
        return dormitoryType;
    }

    public void setDormitoryType(String dormitoryType) {
        this.dormitoryType = dormitoryType;
    }

    public String getBuilding() {
        return building;
    }

    public void setBuilding(String building) {
        this.building = building;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
}