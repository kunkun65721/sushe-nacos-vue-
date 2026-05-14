package com.sushepro.mapper;

import com.sushepro.pojo.DormitoryTransfer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DormitoryTransferMapper {

    DormitoryTransfer findById(@Param("id") Integer id);

    List<DormitoryTransfer> findByStudentId(@Param("studentId") Integer studentId);

    List<DormitoryTransfer> findAll();

    List<DormitoryTransfer> findByStatus(@Param("status") Integer status);

    int insert(DormitoryTransfer dormitoryTransfer);

    int update(DormitoryTransfer dormitoryTransfer);

    int delete(@Param("id") Integer id);
}
