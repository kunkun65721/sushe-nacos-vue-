package com.sushepro.service.impl;

import com.sushepro.mapper.RepairRequestMapper;
import com.sushepro.pojo.RepairRequest;
import com.sushepro.service.RepairRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class RepairRequestServiceImpl implements RepairRequestService {

    @Autowired
    private RepairRequestMapper repairRequestMapper;

    @Override
    public RepairRequest findById(Integer id) {
        return repairRequestMapper.findById(id);
    }

    @Override
    public List<RepairRequest> findByStudentId(Integer studentId) {
        return repairRequestMapper.findByStudentId(studentId);
    }

    @Override
    public List<RepairRequest> findAll() {
        return repairRequestMapper.findAll();
    }

    @Override
    public List<RepairRequest> findByStatus(Integer status) {
        return repairRequestMapper.findByStatus(status);
    }

    @Override
    public int submitRepair(RepairRequest repairRequest) {
        repairRequest.setCreateTime(new Date());
        repairRequest.setUpdateTime(new Date());
        repairRequest.setStatus(0);
        return repairRequestMapper.insert(repairRequest);
    }

    @Override
    public int processRepair(Integer id, String adminComment) {
        RepairRequest repair = repairRequestMapper.findById(id);
        if (repair == null) {
            throw new RuntimeException("报修申请不存在");
        }
        if (repair.getStatus() != 0) {
            throw new RuntimeException("该报修申请已处理，无法重复操作");
        }
        repair.setStatus(1);
        repair.setAdminComment(adminComment);
        repair.setUpdateTime(new Date());
        return repairRequestMapper.update(repair);
    }

    @Override
    public int completeRepair(Integer id, String adminComment) {
        RepairRequest repair = repairRequestMapper.findById(id);
        if (repair == null) {
            throw new RuntimeException("报修申请不存在");
        }
        if (repair.getStatus() != 0 && repair.getStatus() != 1) {
            throw new RuntimeException("该报修申请已完成或已拒绝，无法重复操作");
        }
        repair.setStatus(2);
        repair.setAdminComment(adminComment);
        repair.setUpdateTime(new Date());
        return repairRequestMapper.update(repair);
    }

    @Override
    public int rejectRepair(Integer id, String adminComment) {
        RepairRequest repair = repairRequestMapper.findById(id);
        if (repair == null) {
            throw new RuntimeException("报修申请不存在");
        }
        if (repair.getStatus() != 0) {
            throw new RuntimeException("该报修申请已处理，无法重复操作");
        }
        repair.setStatus(3);
        repair.setAdminComment(adminComment);
        repair.setUpdateTime(new Date());
        return repairRequestMapper.update(repair);
    }

    @Override
    public int deleteRepair(Integer id) {
        return repairRequestMapper.delete(id);
    }

    @Override
    public int countPending() {
        return repairRequestMapper.countPending();
    }
}
