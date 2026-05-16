package com.sushepro.service.impl;

import com.sushepro.mapper.DormitoryTransferMapper;
import com.sushepro.mapper.DormitoryMapper;
import com.sushepro.pojo.Dormitory;
import com.sushepro.pojo.DormitoryAllocation;
import com.sushepro.pojo.DormitoryTransfer;
import com.sushepro.pojo.Notification;
import com.sushepro.pojo.Student;
import com.sushepro.pojo.User;
import com.sushepro.service.DormitoryAllocationService;
import com.sushepro.service.DormitoryTransferService;
import com.sushepro.service.NotificationService;
import com.sushepro.service.StudentService;
import com.sushepro.service.UserService;
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

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private UserService userService;

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
        int result = transferMapper.insert(transfer);

        if (transfer.getId() != null) {
            Student student = studentService.findById(transfer.getStudentId());

            // 学生通知
            Notification studentNotif = new Notification();
            studentNotif.setUserId(student.getUserId());
            studentNotif.setType("transfer_submitted");
            studentNotif.setReferenceId(transfer.getId());
            studentNotif.setReferenceType("transfer");
            studentNotif.setTitle("调换申请已提交");
            studentNotif.setContent(transfer.getReason());
            studentNotif.setRefStatus(0);
            studentNotif.setCreateTime(new Date());
            notificationService.createNotification(studentNotif);

            // 管理员通知
            List<User> admins = userService.findByRole(1);
            for (User admin : admins) {
                Notification adminNotif = new Notification();
                adminNotif.setUserId(admin.getId());
                adminNotif.setType("transfer_submitted");
                adminNotif.setReferenceId(transfer.getId());
                adminNotif.setReferenceType("transfer");
                adminNotif.setTitle("新的调换申请");
                adminNotif.setContent(student.getName() + " 申请调换宿舍");
                adminNotif.setRefStatus(0);
                adminNotif.setRelatedStudentId(student.getId());
                adminNotif.setRelatedStudentName(student.getName());
                adminNotif.setCreateTime(new Date());
                notificationService.createNotification(adminNotif);
            }
        }

        return result;
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
        int result = transferMapper.update(transfer);

        // 学生通知
        Student student = studentService.findById(transfer.getStudentId());
        Notification notif = new Notification();
        notif.setUserId(student.getUserId());
        notif.setType("transfer_approved");
        notif.setReferenceId(transfer.getId());
        notif.setReferenceType("transfer");
        notif.setTitle("调换申请已通过");
        notif.setContent(transfer.getReason());
        notif.setRefStatus(1);
        notif.setCreateTime(new Date());
        notificationService.createNotification(notif);

        return result;
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
        int result = transferMapper.update(transfer);

        // 学生通知
        Student student = studentService.findById(transfer.getStudentId());
        Notification notif = new Notification();
        notif.setUserId(student.getUserId());
        notif.setType("transfer_rejected");
        notif.setReferenceId(transfer.getId());
        notif.setReferenceType("transfer");
        notif.setTitle("调换申请已被拒绝");
        notif.setContent(transfer.getReason());
        notif.setRefStatus(2);
        notif.setCreateTime(new Date());
        notificationService.createNotification(notif);

        return result;
    }

    @Override
    public int deleteTransfer(Integer id) {
        return transferMapper.delete(id);
    }
}
