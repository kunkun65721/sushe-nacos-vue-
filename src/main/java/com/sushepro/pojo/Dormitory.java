package com.sushepro.pojo;

public class Dormitory {
    private Integer id;
    private String dormitoryNumber;
    private String dormitoryType;
    private Integer capacity;
    private Integer currentOccupancy;
    private String building;
    private Integer status; // 0：禁用，1：启用

    // getter and setter methods
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public Integer getCurrentOccupancy() {
        return currentOccupancy;
    }

    public void setCurrentOccupancy(Integer currentOccupancy) {
        this.currentOccupancy = currentOccupancy;
    }

    public String getBuilding() {
        return building;
    }

    public void setBuilding(String building) {
        this.building = building;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}