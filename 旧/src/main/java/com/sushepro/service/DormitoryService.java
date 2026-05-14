package com.sushepro.service;

import com.sushepro.pojo.Dormitory;

import java.util.List;
import java.util.Map;

public interface DormitoryService {
    // 根据ID查询宿舍
    Dormitory findById(Integer id);
    
    // 查询所有宿舍
    List<Dormitory> findAll();
    
    // 添加宿舍
    int addDormitory(Dormitory dormitory);
    
    // 更新宿舍
    int updateDormitory(Dormitory dormitory);
    
    // 删除宿舍
    int deleteDormitory(Integer id);
    
    // 更新宿舍当前入住人数
    int updateCurrentOccupancy(Integer id, Integer currentOccupancy);

    // 统计宿舍入住率数据（总容量和已入住数）
    Map<String, Object> countOccupancyStats();

    // 统计禁用宿舍数（维护中）
    int countDisabled();
}