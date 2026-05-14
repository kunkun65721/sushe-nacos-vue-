package com.sushepro.service.impl;

import com.sushepro.mapper.DormitoryTransferMapper;
import com.sushepro.mapper.DormitoryMapper;
import com.sushepro.pojo.Dormitory;
import com.sushepro.pojo.DormitoryAllocation;
import com.sushepro.pojo.DormitoryTransfer;
import com.sushepro.service.DormitoryAllocationService;
import com.sushepro.service.DormitoryTransferService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class DormitoryTransferServiceImpl implements DormitoryTransferService {

    @Autowired
    private DormitoryTransferMapper transferMapper;

    @Autowired
    private DormitoryAllocationService dormitoryAllocationService;

    @Autowired
    private DormitoryMapper dormitoryMapper;

    @Override
    public DormitoryTransfer findById(Integer id) {
        return transferMapper.findById(id);
    }

    @Override
    public List<DormitoryTransfer> findByStudentId(Integer studentId) {
        return transferMapper.findByStudentId(studentId);
    }

    @Override
    public List<DormitoryTransfer> findAll() {
        return transferMapper.findAll();
    }

    @Override
    public List<DormitoryTransfer> findByStatus(Integer status) {
        return transferMapper.findByStatus(status);
    }

    @Override
    public int submitTransfer(DormitoryTransfer transfer) {
        transfer.setApplyTime(new Date());
        transfer.setStatus(0);
        return transferMapper.insert(transfer);
    }

    @Override
    public int approveTransfer(Integer id, Integer targetDormitoryId, String adminComment) {
        DormitoryTransfer transfer = transferMapper.findById(id);
        if (transfer == null) {
            throw new RuntimeException("调换申请不存在");
        }
        if (transfer.getStatus() != 0) {
            throw new RuntimeException("该申请已处理，无法重复审核");
        }

        Dormitory targetDormitory = dormitoryMapper.findById(targetDormitoryId);
        if (targetDormitory == null) {
            throw new RuntimeException("目标宿舍不存在");
        }
        if (targetDormitory.getStatus() != 1) {
            throw new RuntimeException("目标宿舍已停用");
        }
        if (targetDormitory.getCurrentOccupancy() >= targetDormitory.getCapacity()) {
            throw new RuntimeException("目标宿舍已满，无法分配");
        }

        DormitoryAllocation allocation = new DormitoryAllocation();
        allocation.setStudentId(transfer.getStudentId());
        allocation.setDormitoryId(targetDormitoryId);
        dormitoryAllocationService.allocateDormitory(allocation);

        transfer.setTargetDormitoryId(targetDormitoryId);
        transfer.setStatus(1);
        transfer.setAdminComment(adminComment);
        transfer.setReviewTime(new Date());
        return transferMapper.update(transfer);
    }

    @Override
    public int rejectTransfer(Integer id, String adminComment) {
        DormitoryTransfer transfer = transferMapper.findById(id);
        if (transfer == null) {
            throw new RuntimeException("调换申请不存在");
        }
        if (transfer.getStatus() != 0) {
            throw new RuntimeException("该申请已处理，无法重复审核");
        }

        transfer.setStatus(2);
        transfer.setAdminComment(adminComment);
        transfer.setReviewTime(new Date());
        return transferMapper.update(transfer);
    }

    @Override
    public int deleteTransfer(Integer id) {
        return transferMapper.delete(id);
    }
}
