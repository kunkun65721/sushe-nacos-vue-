package com.sushepro.service.impl;

import com.sushepro.mapper.DormitoryMapper;
import com.sushepro.pojo.Dormitory;
import com.sushepro.service.DormitoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DormitoryServiceImpl implements DormitoryService {
    
    @Autowired
    private DormitoryMapper dormitoryMapper;
    
    @Override
    public Dormitory findById(Integer id) {
        return dormitoryMapper.findById(id);
    }
    
    @Override
    public List<Dormitory> findAll() {
        return dormitoryMapper.findAll();
    }
    
    @Override
    public int addDormitory(Dormitory dormitory) {
        return dormitoryMapper.addDormitory(dormitory);
    }
    
    @Override
    public int updateDormitory(Dormitory dormitory) {
        return dormitoryMapper.updateDormitory(dormitory);
    }
    
    @Override
    public int deleteDormitory(Integer id) {
        return dormitoryMapper.deleteDormitory(id);
    }
    
    @Override
    public int updateCurrentOccupancy(Integer id, Integer currentOccupancy) {
        return dormitoryMapper.updateCurrentOccupancy(id, currentOccupancy);
    }

    @Override
    public Map<String, Object> countOccupancyStats() {
        return dormitoryMapper.countOccupancyStats();
    }

    @Override
    public int countDisabled() {
        return dormitoryMapper.countDisabled();
    }
}