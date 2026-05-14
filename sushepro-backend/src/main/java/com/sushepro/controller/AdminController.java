package com.sushepro.controller;

import com.sushepro.dto.ApiResponse;
import com.sushepro.pojo.*;
import com.sushepro.service.*;
import com.sushepro.util.JwtUtil;
import com.alibaba.fastjson2.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private DormitoryService dormitoryService;

    @Autowired
    private HabitQuestionnaireService habitQuestionnaireService;

    @Autowired
    private DormitoryAllocationService dormitoryAllocationService;

    @Autowired
    private DormitoryTransferService dormitoryTransferService;

    @Autowired
    private RepairRequestService repairRequestService;

    @Autowired
    private AIService aiService;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

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
        int totalStudents = studentService.countAll();
        data.put("totalStudents", totalStudents);

        Map<String, Object> stats = dormitoryService.countOccupancyStats();
        long totalCap = ((Number) stats.get("totalCapacity")).longValue();
        long totalOcc = ((Number) stats.get("totalOccupied")).longValue();
        int occupancyRate = totalCap > 0 ? (int) (totalOcc * 100 / totalCap) : 0;
        data.put("occupancyRate", occupancyRate);

        int pendingAllocations = dormitoryAllocationService.countUnallocatedStudents();
        data.put("pendingAllocations", pendingAllocations);

        int pendingRepairs = repairRequestService.countPending();
        data.put("pendingRepairs", pendingRepairs);

        List<Map<String, Object>> activities = buildAdminActivities();
        data.put("recentActivities", activities);

        return ApiResponse.success(data);
    }

    private List<Map<String, Object>> buildAdminActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        Date now = new Date();

        List<HabitQuestionnaire> recentQuestionnaires = habitQuestionnaireService.findRecent(3);
        for (HabitQuestionnaire q : recentQuestionnaires) {
            Map<String, Object> act = new HashMap<>();
            act.put("description", q.getStudentName() + " 提交了生活习惯问卷");
            act.put("time", q.getCreateTime());
            act.put("relativeTime", formatRelativeTime(q.getCreateTime(), now));
            act.put("icon", "how_to_reg");
            act.put("iconBg", "bg-surface-container");
            activities.add(act);
        }

        List<DormitoryAllocation> recentAllocations = dormitoryAllocationService.findRecent(3);
        for (DormitoryAllocation a : recentAllocations) {
            Map<String, Object> act = new HashMap<>();
            String room = a.getBuilding() != null ? a.getBuilding() + a.getDormitoryNumber() : "宿舍";
            act.put("description", a.getStudentName() + " 被分配到 " + room + " 房间");
            act.put("time", a.getAllocateTime());
            act.put("relativeTime", formatRelativeTime(a.getAllocateTime(), now));
            act.put("icon", "king_bed");
            act.put("iconBg", "bg-surface-container");
            activities.add(act);
        }

        List<RepairRequest> recentRepairs = repairRequestService.findAll();
        int repairCount = 0;
        for (RepairRequest r : recentRepairs) {
            if (repairCount >= 3) break;
            Map<String, Object> act = new HashMap<>();
            String location = r.getBuilding() != null ? r.getBuilding() + r.getDormitoryNumber() : "宿舍";
            act.put("description", location + " 登记了维修请求");
            act.put("time", r.getCreateTime());
            act.put("relativeTime", formatRelativeTime(r.getCreateTime(), now));
            act.put("icon", "plumbing");
            act.put("iconBg", "bg-error-container");
            activities.add(act);
            repairCount++;
        }

        List<DormitoryTransfer> recentTransfers = dormitoryTransferService.findAll();
        int transferCount = 0;
        for (DormitoryTransfer t : recentTransfers) {
            if (transferCount >= 3) break;
            Map<String, Object> act = new HashMap<>();
            act.put("description", t.getStudentName() + " 提交了宿舍调换申请");
            act.put("time", t.getApplyTime());
            act.put("relativeTime", formatRelativeTime(t.getApplyTime(), now));
            act.put("icon", "swap_horiz");
            act.put("iconBg", "bg-surface-container");
            activities.add(act);
            transferCount++;
        }

        activities.sort((a, b) -> {
            Date timeA = (Date) a.get("time");
            Date timeB = (Date) b.get("time");
            if (timeA == null) return 1;
            if (timeB == null) return -1;
            return timeB.compareTo(timeA);
        });

        return activities.size() > 6 ? activities.subList(0, 6) : activities;
    }

    private String formatRelativeTime(Date time, Date now) {
        if (time == null) return "";
        long diff = now.getTime() - time.getTime();
        long minutes = diff / (1000 * 60);
        if (minutes < 1) return "刚刚";
        if (minutes < 60) return minutes + " 分钟前";
        long hours = minutes / 60;
        if (hours < 24) return hours + " 小时前";
        long days = hours / 24;
        if (days < 7) return days + " 天前";
        return new java.text.SimpleDateFormat("yyyy-MM-dd").format(time);
    }

    @GetMapping("/students")
    public ApiResponse<List<Student>> studentList(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        List<Student> studentList = studentService.findAll();
        return ApiResponse.success(studentList);
    }

    @GetMapping("/students/{id}")
    public ApiResponse<Map<String, Object>> studentDetail(@PathVariable("id") Integer id,
                                                           @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> data = new HashMap<>();
        data.put("student", studentService.findById(id));
        data.put("questionnaire", habitQuestionnaireService.findByStudentId(id));
        data.put("allocation", dormitoryAllocationService.findByStudentId(id));
        return ApiResponse.success(data);
    }

    @GetMapping("/dormitories")
    public ApiResponse<List<Dormitory>> dormitoryList(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        List<Dormitory> dormitoryList = dormitoryService.findAll();
        return ApiResponse.success(dormitoryList);
    }

    @PostMapping("/dormitories")
    public ApiResponse<Void> addDormitory(@RequestBody Dormitory dormitory,
                                           @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        dormitory.setCurrentOccupancy(0);
        dormitory.setStatus(1);
        dormitoryService.addDormitory(dormitory);
        return ApiResponse.success();
    }

    @PutMapping("/dormitories/{id}")
    public ApiResponse<Void> editDormitory(@PathVariable("id") Integer id,
                                            @RequestBody Dormitory dormitory,
                                            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        dormitory.setId(id);
        dormitoryService.updateDormitory(dormitory);
        return ApiResponse.success();
    }

    @DeleteMapping("/dormitories/{id}")
    public ApiResponse<Void> deleteDormitory(@PathVariable("id") Integer id,
                                              @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        dormitoryService.deleteDormitory(id);
        return ApiResponse.success();
    }

    @GetMapping("/questionnaires")
    public ApiResponse<Map<String, Object>> questionnaireList(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        List<Student> studentList = studentService.findAll();
        Map<Integer, HabitQuestionnaire> questionnaireMap = new HashMap<>();
        for (Student student : studentList) {
            HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());
            if (questionnaire != null) {
                questionnaireMap.put(student.getId(), questionnaire);
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("students", studentList);
        data.put("questionnaires", questionnaireMap);
        return ApiResponse.success(data);
    }

    @GetMapping("/questionnaires/{studentId}")
    public ApiResponse<Map<String, Object>> questionnaireDetail(@PathVariable("studentId") Integer studentId,
                                                                 @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> data = new HashMap<>();
        data.put("student", studentService.findById(studentId));
        data.put("questionnaire", habitQuestionnaireService.findByStudentId(studentId));
        return ApiResponse.success(data);
    }

    @GetMapping("/allocations")
    public ApiResponse<List<DormitoryAllocation>> allocationList(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        List<DormitoryAllocation> allocationList = dormitoryAllocationService.findAll();
        return ApiResponse.success(allocationList);
    }

    @PostMapping("/allocations")
    public ApiResponse<Void> allocateDormitory(@RequestParam("studentId") Integer studentId,
                                                @RequestParam("dormitoryId") Integer dormitoryId,
                                                @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        DormitoryAllocation allocation = new DormitoryAllocation();
        allocation.setStudentId(studentId);
        allocation.setDormitoryId(dormitoryId);
        dormitoryAllocationService.allocateDormitory(allocation);
        return ApiResponse.success();
    }

    @GetMapping("/transfers")
    public ApiResponse<List<DormitoryTransfer>> transferList(@RequestParam(value = "status", required = false) Integer status,
                                                              @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        List<DormitoryTransfer> transferList;
        if (status != null) {
            transferList = dormitoryTransferService.findByStatus(status);
        } else {
            transferList = dormitoryTransferService.findAll();
        }
        return ApiResponse.success(transferList);
    }

    @GetMapping("/transfers/{id}")
    public ApiResponse<Map<String, Object>> transferDetail(@PathVariable("id") Integer id,
                                                            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> data = new HashMap<>();
        data.put("transfer", dormitoryTransferService.findById(id));
        DormitoryTransfer transfer = dormitoryTransferService.findById(id);
        if (transfer != null) {
            data.put("allocation", dormitoryAllocationService.findByStudentId(transfer.getStudentId()));
            data.put("student", studentService.findById(transfer.getStudentId()));
        }
        data.put("dormitories", dormitoryService.findAll());
        return ApiResponse.success(data);
    }

    @PutMapping("/transfers/{id}/approve")
    public ApiResponse<Void> approveTransfer(@PathVariable("id") Integer id,
                                              @RequestParam("targetDormitoryId") Integer targetDormitoryId,
                                              @RequestParam(value = "adminComment", required = false) String adminComment,
                                              @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        dormitoryTransferService.approveTransfer(id, targetDormitoryId, adminComment);
        return ApiResponse.success();
    }

    @PutMapping("/transfers/{id}/reject")
    public ApiResponse<Void> rejectTransfer(@PathVariable("id") Integer id,
                                            @RequestParam("adminComment") String adminComment,
                                            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        dormitoryTransferService.rejectTransfer(id, adminComment);
        return ApiResponse.success();
    }

    @DeleteMapping("/transfers/{id}")
    public ApiResponse<Void> deleteTransfer(@PathVariable("id") Integer id,
                                            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        dormitoryTransferService.deleteTransfer(id);
        return ApiResponse.success();
    }

    @GetMapping("/repairs")
    public ApiResponse<List<RepairRequest>> repairList(@RequestParam(value = "status", required = false) Integer status,
                                                       @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        List<RepairRequest> repairList;
        if (status != null && status != -1) {
            repairList = repairRequestService.findByStatus(status);
        } else {
            repairList = repairRequestService.findAll();
        }
        return ApiResponse.success(repairList);
    }

    @GetMapping("/repairs/{id}")
    public ApiResponse<Map<String, Object>> repairDetail(@PathVariable("id") Integer id,
                                                          @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> data = new HashMap<>();
        RepairRequest repair = repairRequestService.findById(id);
        data.put("repair", repair);
        if (repair != null) {
            data.put("student", studentService.findById(repair.getStudentId()));
        }
        return ApiResponse.success(data);
    }

    @PutMapping("/repairs/{id}/process")
    public ApiResponse<Void> processRepair(@PathVariable("id") Integer id,
                                          @RequestParam(value = "adminComment", required = false) String adminComment,
                                          @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        repairRequestService.processRepair(id, adminComment);
        return ApiResponse.success();
    }

    @PutMapping("/repairs/{id}/complete")
    public ApiResponse<Void> completeRepair(@PathVariable("id") Integer id,
                                            @RequestParam(value = "adminComment", required = false) String adminComment,
                                            @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        repairRequestService.completeRepair(id, adminComment);
        return ApiResponse.success();
    }

    @PutMapping("/repairs/{id}/reject")
    public ApiResponse<Void> rejectRepair(@PathVariable("id") Integer id,
                                         @RequestParam(value = "adminComment", required = false) String adminComment,
                                         @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        repairRequestService.rejectRepair(id, adminComment);
        return ApiResponse.success();
    }

    @DeleteMapping("/repairs/{id}")
    public ApiResponse<Void> deleteRepair(@PathVariable("id") Integer id,
                                          @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }
        repairRequestService.deleteRepair(id);
        return ApiResponse.success();
    }

    @PostMapping("/ai/recommend")
    public ApiResponse<Map<String, Object>> aiRecommend(@RequestParam("studentId") Integer studentId,
                                                        @RequestParam(value = "remark", required = false) String remark,
                                                        @RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        RecommendationResult result = aiService.getDormitoryRecommendation(studentId, remark);
        Map<String, Object> data = new HashMap<>();
        data.put("recommendation", result.getText());
        data.put("scores", result.getScores());
        return ApiResponse.success(data);
    }

    @GetMapping("/notifications")
    public ApiResponse<Map<String, Object>> getNotifications(@RequestHeader("Authorization") String authHeader) {
        User user = getUserFromToken(authHeader);
        if (user == null) {
            return ApiResponse.unauthorized();
        }

        Map<String, Object> data = new HashMap<>();
        data.put("pendingRepairs", repairRequestService.countPending());
        data.put("pendingTransfers", dormitoryTransferService.findByStatus(0) != null ?
                dormitoryTransferService.findByStatus(0).size() : 0);
        data.put("recentAllocations", dormitoryAllocationService.findRecent(10));
        return ApiResponse.success(data);
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