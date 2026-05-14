package com.sushepro.service;

import com.sushepro.pojo.DormitoryAllocation;

import java.util.List;

public interface DormitoryAllocationService {
    // 根据ID查询宿舍分配
    DormitoryAllocation findById(Integer id);
    
    // 根据学生ID查询宿舍分配
    DormitoryAllocation findByStudentId(Integer studentId);
    
    // 根据宿舍ID查询宿舍分配
    List<DormitoryAllocation> findByDormitoryId(Integer dormitoryId);
    
    // 查询所有宿舍分配
    List<DormitoryAllocation> findAll();
    
    // 分配宿舍
    int allocateDormitory(DormitoryAllocation dormitoryAllocation);
    
    // 更新宿舍分配
    int updateDormitoryAllocation(DormitoryAllocation dormitoryAllocation);
    
    // 删除宿舍分配
    int deleteDormitoryAllocation(Integer id);

    // 统计未分配宿舍的学生数
    int countUnallocatedStudents();

    // 查询最近分配记录
    List<DormitoryAllocation> findRecent(int limit);
}