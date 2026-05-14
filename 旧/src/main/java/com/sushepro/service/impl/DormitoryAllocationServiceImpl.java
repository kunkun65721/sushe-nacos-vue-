package com.sushepro.service.impl;

import com.sushepro.mapper.DormitoryAllocationMapper;
import com.sushepro.mapper.DormitoryMapper;
import com.sushepro.pojo.Dormitory;
import com.sushepro.pojo.DormitoryAllocation;
import com.sushepro.service.DormitoryAllocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class DormitoryAllocationServiceImpl implements DormitoryAllocationService {
    
    @Autowired
    private DormitoryAllocationMapper dormitoryAllocationMapper;
    
    @Autowired
    private DormitoryMapper dormitoryMapper;
    
    @Override
    public DormitoryAllocation findById(Integer id) {
        return dormitoryAllocationMapper.findById(id);
    }
    
    @Override
    public DormitoryAllocation findByStudentId(Integer studentId) {
        return dormitoryAllocationMapper.findByStudentId(studentId);
    }
    
    @Override
    public List<DormitoryAllocation> findByDormitoryId(Integer dormitoryId) {
        return dormitoryAllocationMapper.findByDormitoryId(dormitoryId);
    }
    
    @Override
    public List<DormitoryAllocation> findAll() {
        return dormitoryAllocationMapper.findAll();
    }
    
    @Override
    public int allocateDormitory(DormitoryAllocation dormitoryAllocation) {
        // 设置分配时间
        dormitoryAllocation.setAllocateTime(new Date());
        
        int result;
        // 检查学生是否已有宿舍分配
        DormitoryAllocation existingAllocation = findByStudentId(dormitoryAllocation.getStudentId());
        
        if (existingAllocation != null) {
            // 如果已有分配，先将原宿舍的入住人数减1
            Dormitory oldDormitory = dormitoryMapper.findById(existingAllocation.getDormitoryId());
            if (oldDormitory != null) {
                int oldOccupancy = oldDormitory.getCurrentOccupancy() - 1;
                oldDormitory.setCurrentOccupancy(Math.max(oldOccupancy, 0));
                dormitoryMapper.updateDormitory(oldDormitory);
            }
            
            // 更新现有分配记录
            dormitoryAllocation.setId(existingAllocation.getId());
            result = dormitoryAllocationMapper.updateDormitoryAllocation(dormitoryAllocation);
        } else {
            // 如果没有分配，添加新记录
            result = dormitoryAllocationMapper.addDormitoryAllocation(dormitoryAllocation);
        }
        
        if (result > 0) {
            // 更新新宿舍的当前入住人数
            Dormitory newDormitory = dormitoryMapper.findById(dormitoryAllocation.getDormitoryId());
            if (newDormitory != null) {
                int newOccupancy = newDormitory.getCurrentOccupancy() + 1;
                dormitoryMapper.updateCurrentOccupancy(newDormitory.getId(), newOccupancy);
            }
        }
        
        return result;
    }
    
    @Override
    public int updateDormitoryAllocation(DormitoryAllocation dormitoryAllocation) {
        return dormitoryAllocationMapper.updateDormitoryAllocation(dormitoryAllocation);
    }
    
    @Override
    public int countUnallocatedStudents() {
        return dormitoryAllocationMapper.countUnallocatedStudents();
    }

    @Override
    public List<DormitoryAllocation> findRecent(int limit) {
        return dormitoryAllocationMapper.findRecent(limit);
    }

    @Override
    public int deleteDormitoryAllocation(Integer id) {
        // 查询宿舍分配记录
        DormitoryAllocation dormitoryAllocation = dormitoryAllocationMapper.findById(id);
        
        if (dormitoryAllocation != null) {
            // 删除宿舍分配记录
            int result = dormitoryAllocationMapper.deleteDormitoryAllocation(id);
            
            if (result > 0) {
                // 更新宿舍当前入住人数
                Dormitory dormitory = dormitoryMapper.findById(dormitoryAllocation.getDormitoryId());
                if (dormitory != null) {
                    int newOccupancy = dormitory.getCurrentOccupancy() - 1;
                    // 确保入住人数不为负数
                    newOccupancy = Math.max(newOccupancy, 0);
                    dormitoryMapper.updateCurrentOccupancy(dormitory.getId(), newOccupancy);
                }
            }
            
            return result;
        }
        
        return 0;
    }
}