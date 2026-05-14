package com.sushepro.service;

import com.sushepro.pojo.RepairRequest;

import java.util.List;

public interface RepairRequestService {
    RepairRequest findById(Integer id);
    List<RepairRequest> findByStudentId(Integer studentId);
    List<RepairRequest> findAll();
    List<RepairRequest> findByStatus(Integer status);
    int submitRepair(RepairRequest repairRequest);
    int processRepair(Integer id, String adminComment);
    int completeRepair(Integer id, String adminComment);
    int rejectRepair(Integer id, String adminComment);
    int deleteRepair(Integer id);

    int countPending();
}
