package com.sushepro.service.impl;

import com.sushepro.mapper.RepairRequestMapper;
import com.sushepro.pojo.Notification;
import com.sushepro.pojo.RepairRequest;
import com.sushepro.pojo.Student;
import com.sushepro.pojo.User;
import com.sushepro.service.NotificationService;
import com.sushepro.service.RepairRequestService;
import com.sushepro.service.StudentService;
import com.sushepro.service.UserService;
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

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private UserService userService;

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
        int result = repairRequestMapper.insert(repairRequest);

        if (repairRequest.getId() != null) {
            Student student = studentService.findById(repairRequest.getStudentId());
            String content = (repairRequest.getBuilding() != null ? repairRequest.getBuilding() : "")
                    + (repairRequest.getDormitoryNumber() != null ? repairRequest.getDormitoryNumber() : "")
                    + " - " + (repairRequest.getDescription() != null ? repairRequest.getDescription() : "");

            // 学生通知
            Notification studentNotif = new Notification();
            studentNotif.setUserId(student.getUserId());
            studentNotif.setType("repair_submitted");
            studentNotif.setReferenceId(repairRequest.getId());
            studentNotif.setReferenceType("repair");
            studentNotif.setTitle("报修申请已提交");
            studentNotif.setContent(content);
            studentNotif.setRefStatus(0);
            studentNotif.setCreateTime(new Date());
            notificationService.createNotification(studentNotif);

            // 管理员通知
            List<User> admins = userService.findByRole(1);
            for (User admin : admins) {
                Notification adminNotif = new Notification();
                adminNotif.setUserId(admin.getId());
                adminNotif.setType("repair_submitted");
                adminNotif.setReferenceId(repairRequest.getId());
                adminNotif.setReferenceType("repair");
                adminNotif.setTitle("新的报修申请");
                adminNotif.setContent(content);
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
        int result = repairRequestMapper.update(repair);

        // 学生通知
        Student student = studentService.findById(repair.getStudentId());
        Notification notif = new Notification();
        notif.setUserId(student.getUserId());
        notif.setType("repair_processing");
        notif.setReferenceId(repair.getId());
        notif.setReferenceType("repair");
        notif.setTitle("报修正在处理中");
        notif.setContent(repair.getDescription());
        notif.setRefStatus(1);
        notif.setCreateTime(new Date());
        notificationService.createNotification(notif);

        return result;
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
        int result = repairRequestMapper.update(repair);

        // 学生通知
        Student student = studentService.findById(repair.getStudentId());
        Notification notif = new Notification();
        notif.setUserId(student.getUserId());
        notif.setType("repair_completed");
        notif.setReferenceId(repair.getId());
        notif.setReferenceType("repair");
        notif.setTitle("报修已完成");
        notif.setContent(repair.getDescription());
        notif.setRefStatus(2);
        notif.setCreateTime(new Date());
        notificationService.createNotification(notif);

        return result;
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
        int result = repairRequestMapper.update(repair);

        // 学生通知
        Student student = studentService.findById(repair.getStudentId());
        Notification notif = new Notification();
        notif.setUserId(student.getUserId());
        notif.setType("repair_rejected");
        notif.setReferenceId(repair.getId());
        notif.setReferenceType("repair");
        notif.setTitle("报修已被拒绝");
        notif.setContent(repair.getDescription());
        notif.setRefStatus(3);
        notif.setCreateTime(new Date());
        notificationService.createNotification(notif);

        return result;
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
