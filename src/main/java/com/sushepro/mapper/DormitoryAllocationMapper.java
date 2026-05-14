package com.sushepro.mapper;

import com.sushepro.pojo.DormitoryAllocation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DormitoryAllocationMapper {
    // 根据ID查询宿舍分配
    DormitoryAllocation findById(@Param("id") Integer id);
    
    // 根据学生ID查询宿舍分配
    DormitoryAllocation findByStudentId(@Param("studentId") Integer studentId);
    
    // 根据宿舍ID查询宿舍分配
    List<DormitoryAllocation> findByDormitoryId(@Param("dormitoryId") Integer dormitoryId);
    
    // 查询所有宿舍分配
    List<DormitoryAllocation> findAll();
    
    // 添加宿舍分配
    int addDormitoryAllocation(DormitoryAllocation dormitoryAllocation);
    
    // 更新宿舍分配
    int updateDormitoryAllocation(DormitoryAllocation dormitoryAllocation);
    
    // 删除宿舍分配
    int deleteDormitoryAllocation(@Param("id") Integer id);

    // 统计未分配宿舍的学生数
    int countUnallocatedStudents();

    // 查询最近分配记录（含学生姓名）
    List<DormitoryAllocation> findRecent(@Param("limit") int limit);
}