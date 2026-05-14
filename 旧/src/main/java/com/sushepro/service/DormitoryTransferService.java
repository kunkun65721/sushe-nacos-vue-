package com.sushepro.service;

import com.sushepro.pojo.DormitoryTransfer;

import java.util.List;

public interface DormitoryTransferService {

    DormitoryTransfer findById(Integer id);

    List<DormitoryTransfer> findByStudentId(Integer studentId);

    List<DormitoryTransfer> findAll();

    List<DormitoryTransfer> findByStatus(Integer status);

    int submitTransfer(DormitoryTransfer transfer);

    int approveTransfer(Integer id, Integer targetDormitoryId, String adminComment);

    int rejectTransfer(Integer id, String adminComment);

    int deleteTransfer(Integer id);
}
