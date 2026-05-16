package com.sushepro.controller;

import com.sushepro.dto.ApiResponse;
import com.sushepro.pojo.*;
import com.sushepro.service.*;
import com.sushepro.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import java.util.UUID;

@RestController
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private HabitQuestionnaireService habitQuestionnaireService;

    @Autowired
    private DormitoryAllocationService dormitoryAllocationService;

    @Autowired
    private DormitoryTransferService dormitoryTransferService;

    @Autowired
    private RepairRequestService repairRequestService;

    @Autowired
    private DormitoryService dormitoryService;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private NotificationService notificationService;

    private User getUserFromToken(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            return null;
        }
        Integer userId = jwtUtil.getUserIdFromToken(token);
        return userService.findById(userId);
    }

    @GetMapping("/index")
    public ApiResponse<Map<String, Object>> index(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> data = new HashMap<>();
        Student student = studentService.findByUserId(user.getId());
        data.put("student", student);

        if (student != null) {
            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            data.put("allocation", allocation);

            List<RepairRequest> repairList = repairRequestService.findByStudentId(student.getId());
            data.put("repairList", repairList);
            data.put("pendingRepairs", repairList != null ?
                (int) repairList.stream().filter(r -> r.getStatus() != null && r.getStatus() == 2).count() : 0);
            data.put("totalRepairs", repairList != null ? repairList.size() : 0);

            List<DormitoryTransfer> transferList = dormitoryTransferService.findByStudentId(student.getId());
            data.put("transferList", transferList);
            data.put("latestTransfer", transferList != null && !transferList.isEmpty() ? transferList.get(0) : null);

            HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());
            data.put("hasQuestionnaire", questionnaire != null);

            List<Map<String, Object>> activities = buildActivities(questionnaire, allocation, repairList, transferList);
            data.put("recentActivities", activities);
        }

        return ApiResponse.success(data);
    }

    private List<Map<String, Object>> buildActivities(HabitQuestionnaire questionnaire,
                                                      DormitoryAllocation allocation,
                                                      List<RepairRequest> repairList,
                                                      List<DormitoryTransfer> transferList) {
        List<Map<String, Object>> activities = new ArrayList<>();

        if (questionnaire != null && questionnaire.getCreateTime() != null) {
            Map<String, Object> act = new HashMap<>();
            act.put("description", "提交了生活习惯问卷");
            act.put("time", questionnaire.getCreateTime());
            act.put("icon", "quiz");
            act.put("iconBg", "bg-primary-fixed");
            activities.add(act);
        }

        if (allocation != null && allocation.getAllocateTime() != null) {
            Map<String, Object> act = new HashMap<>();
            act.put("description", "分配到 " + (allocation.getBuilding() != null ? allocation.getBuilding() : "") + allocation.getDormitoryNumber() + " 房间");
            act.put("time", allocation.getAllocateTime());
            act.put("icon", "king_bed");
            act.put("iconBg", "bg-secondary-fixed");
            activities.add(act);
        }

        if (repairList != null) {
            for (RepairRequest r : repairList) {
                Map<String, Object> act = new HashMap<>();
                String statusText = r.getStatus() == 0 ? "提交了" : r.getStatus() == 1 ? "处理中：" : r.getStatus() == 2 ? "已完成：" : "已拒绝：";
                act.put("description", statusText + "报修申请");
                act.put("time", r.getCreateTime());
                act.put("icon", "build");
                act.put("iconBg", r.getStatus() == 2 ? "bg-error-container" : "bg-tertiary-fixed");
                activities.add(act);
            }
        }

        if (transferList != null) {
            for (DormitoryTransfer t : transferList) {
                Map<String, Object> act = new HashMap<>();
                String statusText = t.getStatus() == 0 ? "提交了" : t.getStatus() == 1 ? "已通过：" : "已拒绝：";
                act.put("description", statusText + "宿舍调换申请");
                act.put("time", t.getApplyTime());
                act.put("icon", "swap_horiz");
                act.put("iconBg", t.getStatus() == 1 ? "bg-primary-fixed" : "bg-surface-container");
                activities.add(act);
            }
        }

        activities.sort((a, b) -> {
            Date timeA = (Date) a.get("time");
            Date timeB = (Date) b.get("time");
            if (timeA == null) return 1;
            if (timeB == null) return -1;
            return timeB.compareTo(timeA);
        });

        return activities;
    }

    @GetMapping("/profile")
    public ApiResponse<Student> profile(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        return ApiResponse.success(student);
    }

    @GetMapping("/questionnaire")
    public ApiResponse<HabitQuestionnaire> getQuestionnaire(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }
        HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());
        return ApiResponse.success(questionnaire);
    }

    @PostMapping("/questionnaire")
    public ApiResponse<Void> submitQuestionnaire(@RequestBody HabitQuestionnaire questionnaire,
                                                  @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }
        questionnaire.setStudentId(student.getId());
        habitQuestionnaireService.submitQuestionnaire(questionnaire);
        return ApiResponse.success();
    }

    @GetMapping("/allocation")
    public ApiResponse<DormitoryAllocation> getAllocation(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }
        DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
        return ApiResponse.success(allocation);
    }

    @GetMapping("/transfers")
    public ApiResponse<List<DormitoryTransfer>> getTransfers(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }
        List<DormitoryTransfer> transferList = dormitoryTransferService.findByStudentId(student.getId());
        return ApiResponse.success(transferList);
    }

    @GetMapping("/dormitories")
    public ApiResponse<List<Dormitory>> getDormitories(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        List<Dormitory> dormitoryList = dormitoryService.findAll();
        return ApiResponse.success(dormitoryList);
    }

    @PostMapping("/transfers")
    public ApiResponse<Void> submitTransfer(@RequestParam("reason") String reason,
                                            @RequestParam(value = "targetDormitoryId", required = false) Integer targetDormitoryId,
                                            @RequestParam(value = "attachment", required = false) MultipartFile attachment,
                                            @RequestHeader("Authorization") String authHeader,
                                            HttpServletRequest request) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }

        DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
        if (allocation == null) {
            return ApiResponse.error("当前未分配宿舍，无法申请调换");
        }

        DormitoryTransfer transfer = new DormitoryTransfer();
        transfer.setStudentId(student.getId());
        transfer.setCurrentDormitoryId(allocation.getDormitoryId());
        transfer.setTargetDormitoryId(targetDormitoryId);
        transfer.setReason(reason);

        if (attachment != null && !attachment.isEmpty()) {
            try {
                String savedPath = saveFile(request, attachment, "transfer");
                transfer.setAttachment(savedPath);
            } catch (IOException e) {
                return ApiResponse.error("文件上传失败");
            }
        }

        dormitoryTransferService.submitTransfer(transfer);
        return ApiResponse.success();
    }

    @GetMapping("/repairs")
    public ApiResponse<List<RepairRequest>> getRepairs(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }
        List<RepairRequest> repairList = repairRequestService.findByStudentId(student.getId());
        return ApiResponse.success(repairList);
    }

    @PostMapping("/repairs")
    public ApiResponse<Void> submitRepair(@RequestParam("description") String description,
                                          @RequestParam(value = "image", required = false) MultipartFile image,
                                          @RequestHeader("Authorization") String authHeader,
                                          HttpServletRequest request) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        Student student = studentService.findByUserId(user.getId());
        if (student == null) {
            return ApiResponse.notFound();
        }

        RepairRequest repair = new RepairRequest();
        repair.setStudentId(student.getId());
        repair.setDescription(description);

        DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
        if (allocation != null) {
            repair.setDormitoryId(allocation.getDormitoryId());
        }

        if (image != null && !image.isEmpty()) {
            try {
                String savedPath = saveFile(request, image, "repair");
                repair.setImage(savedPath);
            } catch (IOException e) {
                return ApiResponse.error("图片上传失败");
            }
        }

        repairRequestService.submitRepair(repair);
        return ApiResponse.success();
    }

    private String saveFile(HttpServletRequest request, MultipartFile file, String subDir) throws IOException {
        // 使用项目根目录下的 uploads 文件夹，便于静态资源访问
        // user.dir 默认是后端模块目录，需要回退两级到项目根目录
        String projectRoot = new File(System.getProperty("user.dir")).getParent();
        String uploadDir = projectRoot + File.separator + "uploads" + File.separator + subDir;
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String originalName = file.getOriginalFilename();
        String ext = originalName != null && originalName.contains(".") ?
                originalName.substring(originalName.lastIndexOf(".")) : "";
        String savedName = UUID.randomUUID().toString() + ext;
        file.transferTo(new File(dir, savedName));
        return "uploads/" + subDir + "/" + savedName;
    }

    @GetMapping("/notifications")
    public ApiResponse<Map<String, Object>> getNotifications(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        List<Notification> notifications = notificationService.findActiveByUserId(user.getId());

        List<Map<String, Object>> repairNotifs = new ArrayList<>();
        List<Map<String, Object>> transferNotifs = new ArrayList<>();
        Map<String, Object> allocNotif = null;

        for (Notification n : notifications) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", n.getId());
            m.put("referenceId", n.getReferenceId());
            m.put("type", n.getReferenceType());
            m.put("title", n.getTitle());
            m.put("description", n.getContent());
            m.put("time", n.getCreateTime());
            m.put("status", n.getRefStatus());
            m.put("isRead", n.getIsRead());

            // 根据类型设置图标
            String icon;
            switch (n.getType()) {
                case "repair_submitted": icon = "plumbing"; break;
                case "repair_processing": icon = "engineering"; break;
                case "repair_completed": icon = "check_circle"; break;
                case "repair_rejected": icon = "cancel"; break;
                case "transfer_submitted": icon = "swap_horiz"; break;
                case "transfer_approved": icon = "check_circle"; break;
                case "transfer_rejected": icon = "cancel"; break;
                case "allocation_created": icon = "king_bed"; break;
                default: icon = "notifications";
            }
            m.put("icon", icon);

            if ("repair".equals(n.getReferenceType())) {
                repairNotifs.add(m);
            } else if ("transfer".equals(n.getReferenceType())) {
                transferNotifs.add(m);
            } else if ("allocation".equals(n.getReferenceType())) {
                allocNotif = m;
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("repairs", repairNotifs);
        data.put("transfers", transferNotifs);
        data.put("allocation", allocNotif);
        return ApiResponse.success(data);
    }

    @DeleteMapping("/notifications/repair/{id}")
    public ApiResponse<Void> deleteRepairNotification(@PathVariable("id") Integer id,
                                                     @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        notificationService.markAsDeleted(id);
        return ApiResponse.success();
    }

    @DeleteMapping("/notifications/transfer/{id}")
    public ApiResponse<Void> deleteTransferNotification(@PathVariable("id") Integer id,
                                                      @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        notificationService.markAsDeleted(id);
        return ApiResponse.success();
    }

    @PostMapping("/password")
    public ApiResponse<Void> changePassword(@RequestParam("oldPassword") String oldPassword,
                                             @RequestParam("newPassword") String newPassword,
                                             @RequestParam("confirmPassword") String confirmPassword,
                                             @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        if (!user.getPassword().equals(oldPassword)) {
            return ApiResponse.error("旧密码不正确");
        }

        if (!newPassword.equals(confirmPassword)) {
            return ApiResponse.error("两次输入的新密码不一致");
        }

        if (newPassword.length() < 1) {
            return ApiResponse.error("新密码不能为空");
        }

        user.setPassword(newPassword);
        userService.updateUser(user);
        return ApiResponse.success();
    }
}