package com.sushepro.mapper;

import com.sushepro.pojo.RepairRequest;

import java.util.List;

public interface RepairRequestMapper {
    RepairRequest findById(Integer id);
    List<RepairRequest> findByStudentId(Integer studentId);
    List<RepairRequest> findAll();
    List<RepairRequest> findByStatus(Integer status);
    int insert(RepairRequest repairRequest);
    int update(RepairRequest repairRequest);
    int delete(Integer id);

    int countPending();
}
