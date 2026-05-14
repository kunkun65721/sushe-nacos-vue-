package com.sushepro.controller;

import com.sushepro.pojo.Student;
import com.sushepro.pojo.Dormitory;
import com.sushepro.pojo.HabitQuestionnaire;
import com.sushepro.pojo.DormitoryAllocation;
import com.sushepro.pojo.DormitoryTransfer;
import com.sushepro.pojo.RepairRequest;
import com.sushepro.pojo.RecommendationResult;
import com.sushepro.service.StudentService;
import com.sushepro.service.DormitoryService;
import com.sushepro.service.HabitQuestionnaireService;
import com.sushepro.service.DormitoryAllocationService;
import com.sushepro.service.DormitoryTransferService;
import com.sushepro.service.RepairRequestService;
import com.sushepro.pojo.User;
import com.sushepro.service.AIService;
import com.sushepro.service.UserService;
import com.alibaba.fastjson.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
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

    // REST API: 获取所有分配记录
    @GetMapping("/allocations")
    @ResponseBody
    public void getAllocationsApi(HttpServletResponse response) throws Exception {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        List<DormitoryAllocation> list = dormitoryAllocationService.findAll();
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("data", list);
        response.getWriter().write(JSON.toJSONString(result));
    }

    // 管理员首页
    @GetMapping("/index")
    public String index(Model model) {
        int totalStudents = studentService.countAll();

        Map<String, Object> stats = dormitoryService.countOccupancyStats();
        long totalCap = ((Number) stats.get("totalCapacity")).longValue();
        long totalOcc = ((Number) stats.get("totalOccupied")).longValue();
        int occupancyRate = totalCap > 0 ? (int) (totalOcc * 100 / totalCap) : 0;

        int pendingAllocations = dormitoryAllocationService.countUnallocatedStudents();

        int pendingRepairs = repairRequestService.countPending();

        // 构建最近活动列表
        List<Map<String, Object>> activities = new ArrayList<>();
        Date now = new Date();

        // 问卷提交
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

        // 宿舍分配
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

        // 报修请求
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

        // 调换申请
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

        // 按时间倒序，取前 6 条
        activities.sort((a, b) -> ((Date) b.get("time")).compareTo((Date) a.get("time")));
        if (activities.size() > 6) {
            activities = activities.subList(0, 6);
        }

        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("occupancyRate", occupancyRate);
        model.addAttribute("pendingAllocations", pendingAllocations);
        model.addAttribute("pendingRepairs", pendingRepairs);
        model.addAttribute("recentActivities", activities);
        return "admin/index";
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
    
    // 学生管理页面
    @GetMapping("/student/list")
    public String studentList(Model model) {
        // 查询所有学生
        List<Student> studentList = studentService.findAll();
        model.addAttribute("studentList", studentList);
        return "admin/student/list";
    }
    
    // 查看学生详情
    @GetMapping("/student/detail")
    public String studentDetail(@RequestParam("id") Integer id, Model model) {
        // 查询学生信息
        Student student = studentService.findById(id);
        model.addAttribute("student", student);
        
        // 查询学生的生活习惯问卷
        HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(id);
        model.addAttribute("questionnaire", questionnaire);
        
        // 查询学生的宿舍分配情况
        DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(id);
        model.addAttribute("allocation", allocation);
        
        return "admin/student/detail";
    }
    
    // 宿舍管理页面
    @GetMapping("/dormitory/list")
    public String dormitoryList(Model model) {
        // 查询所有宿舍
        List<Dormitory> dormitoryList = dormitoryService.findAll();
        model.addAttribute("dormitoryList", dormitoryList);
        return "admin/dormitory/list";
    }
    
    // 跳转到添加宿舍页面
    @GetMapping("/dormitory/add")
    public String toAddDormitory() {
        return "admin/dormitory/add";
    }
    
    // 添加宿舍
    @PostMapping("/dormitory/add")
    public String addDormitory(Dormitory dormitory) {
        // 设置初始入住人数为0
        dormitory.setCurrentOccupancy(0);
        // 设置状态为启用
        dormitory.setStatus(1);
        
        // 添加宿舍
        dormitoryService.addDormitory(dormitory);
        
        // 跳转到宿舍列表页面
        return "redirect:/admin/dormitory/list";
    }
    
    // 跳转到编辑宿舍页面
    @GetMapping("/dormitory/edit")
    public String toEditDormitory(@RequestParam("id") Integer id, Model model) {
        // 查询宿舍信息
        Dormitory dormitory = dormitoryService.findById(id);
        model.addAttribute("dormitory", dormitory);
        
        return "admin/dormitory/edit";
    }
    
    // 编辑宿舍
    @PostMapping("/dormitory/edit")
    public String editDormitory(Dormitory dormitory) {
        // 更新宿舍信息
        dormitoryService.updateDormitory(dormitory);
        
        // 跳转到宿舍列表页面
        return "redirect:/admin/dormitory/list";
    }
    
    // 删除宿舍
    @GetMapping("/dormitory/delete")
    public String deleteDormitory(@RequestParam("id") Integer id) {
        // 删除宿舍
        dormitoryService.deleteDormitory(id);
        
        // 跳转到宿舍列表页面
        return "redirect:/admin/dormitory/list";
    }
    
    // 生活习惯问卷管理页面
    @GetMapping("/habitQuestionnaire/list")
    public String habitQuestionnaireList(Model model) {
        // 查询所有学生
        List<Student> studentList = studentService.findAll();
        model.addAttribute("studentList", studentList);
        
        // 查询每个学生的生活习惯问卷状态
        Map<Integer, Boolean> questionnaireStatusMap = new HashMap<>();
        for (Student student : studentList) {
            HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());
            questionnaireStatusMap.put(student.getId(), questionnaire != null);
        }
        model.addAttribute("questionnaireStatusMap", questionnaireStatusMap);
        
        return "admin/habitQuestionnaire/list";
    }
    
    // 查看学生生活习惯问卷
    @GetMapping("/habitQuestionnaire/detail")
    public String habitQuestionnaireDetail(@RequestParam("studentId") Integer studentId, Model model) {
        // 查询学生信息
        Student student = studentService.findById(studentId);
        model.addAttribute("student", student);
        
        // 查询学生的生活习惯问卷
        HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(studentId);
        model.addAttribute("questionnaire", questionnaire);
        
        return "admin/habitQuestionnaire/detail";
    }
    
    // 宿舍分配页面
    @GetMapping("/allocation/list")
    public String allocationList(Model model) {
        // 查询所有宿舍分配情况
        List<DormitoryAllocation> allocationList = dormitoryAllocationService.findAll();
        model.addAttribute("allocationList", allocationList);
        
        return "admin/allocation/list";
    }
    
    // 跳转到分配宿舍页面
    @GetMapping("/allocation/allocate")
    public String toAllocateDormitory(@RequestParam("studentId") Integer studentId, Model model) {
        // 查询学生信息
        Student student = studentService.findById(studentId);
        model.addAttribute("student", student);
        
        // 查询所有可用宿舍
        List<Dormitory> dormitoryList = dormitoryService.findAll();
        model.addAttribute("dormitoryList", dormitoryList);
        
        return "admin/allocation/allocate";
    }
    
    // 分配宿舍
    @PostMapping("/allocation/allocate")
    public String allocateDormitory(@RequestParam("studentId") Integer studentId,
                                   @RequestParam("dormitoryId") Integer dormitoryId) {
        // 创建宿舍分配对象
        DormitoryAllocation allocation = new DormitoryAllocation();
        allocation.setStudentId(studentId);
        allocation.setDormitoryId(dormitoryId);
        
        // 分配宿舍
        dormitoryAllocationService.allocateDormitory(allocation);
        
        // 跳转到学生详情页面
        return "redirect:/admin/student/detail?id=" + studentId;
    }
    
    // 宿舍调换管理页面
    @GetMapping("/transfer/list")
    public String transferList(@RequestParam(value = "status", required = false) Integer status, Model model) {
        List<DormitoryTransfer> transferList;
        if (status != null) {
            transferList = dormitoryTransferService.findByStatus(status);
            model.addAttribute("statusFilter", status);
        } else {
            transferList = dormitoryTransferService.findAll();
            model.addAttribute("statusFilter", -1);
        }
        model.addAttribute("transferList", transferList);
        return "admin/transfer/list";
    }

    // 查看调换申请详情
    @GetMapping("/transfer/detail")
    public String transferDetail(@RequestParam("id") Integer id, Model model) {
        DormitoryTransfer transfer = dormitoryTransferService.findById(id);
        model.addAttribute("transfer", transfer);

        DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(transfer.getStudentId());
        model.addAttribute("allocation", allocation);

        Student student = studentService.findById(transfer.getStudentId());
        model.addAttribute("student", student);

        List<Dormitory> dormitoryList = dormitoryService.findAll();
        model.addAttribute("dormitoryList", dormitoryList);

        return "admin/transfer/detail";
    }

    // 通过调换申请
    @PostMapping("/transfer/approve")
    public String approveTransfer(@RequestParam("id") Integer id,
                                  @RequestParam("targetDormitoryId") Integer targetDormitoryId,
                                  @RequestParam(value = "adminComment", required = false) String adminComment) {
        dormitoryTransferService.approveTransfer(id, targetDormitoryId, adminComment);
        return "redirect:/admin/transfer/list";
    }

    // 拒绝调换申请
    @PostMapping("/transfer/reject")
    public String rejectTransfer(@RequestParam("id") Integer id,
                                 @RequestParam("adminComment") String adminComment) {
        dormitoryTransferService.rejectTransfer(id, adminComment);
        return "redirect:/admin/transfer/list";
    }

    // 删除调换申请
    @GetMapping("/transfer/delete")
    public String deleteTransfer(@RequestParam("id") Integer id) {
        dormitoryTransferService.deleteTransfer(id);
        return "redirect:/admin/transfer/list";
    }

    // 报修管理页面
    @GetMapping("/repair/list")
    public String repairList(@RequestParam(value = "status", required = false) Integer status, Model model) {
        List<RepairRequest> repairList;
        if (status != null && status != -1) {
            repairList = repairRequestService.findByStatus(status);
            model.addAttribute("statusFilter", status);
        } else {
            repairList = repairRequestService.findAll();
            model.addAttribute("statusFilter", -1);
        }
        model.addAttribute("repairList", repairList);
        return "admin/repair/list";
    }

    // 查看报修详情
    @GetMapping("/repair/detail")
    public String repairDetail(@RequestParam("id") Integer id, Model model) {
        RepairRequest repair = repairRequestService.findById(id);
        model.addAttribute("repair", repair);

        Student student = studentService.findById(repair.getStudentId());
        model.addAttribute("student", student);

        return "admin/repair/detail";
    }

    // 标记报修处理中
    @PostMapping("/repair/process")
    public String processRepair(@RequestParam("id") Integer id,
                                @RequestParam(value = "adminComment", required = false) String adminComment) {
        repairRequestService.processRepair(id, adminComment);
        return "redirect:/admin/repair/list";
    }

    // 标记报修已完成
    @PostMapping("/repair/complete")
    public String completeRepair(@RequestParam("id") Integer id,
                                 @RequestParam(value = "adminComment", required = false) String adminComment) {
        repairRequestService.completeRepair(id, adminComment);
        return "redirect:/admin/repair/list";
    }

    // 拒绝报修
    @PostMapping("/repair/reject")
    public String rejectRepair(@RequestParam("id") Integer id,
                               @RequestParam(value = "adminComment", required = false) String adminComment) {
        repairRequestService.rejectRepair(id, adminComment);
        return "redirect:/admin/repair/list";
    }

    // 删除报修
    @GetMapping("/repair/delete")
    public String deleteRepair(@RequestParam("id") Integer id) {
        repairRequestService.deleteRepair(id);
        return "redirect:/admin/repair/list";
    }

    // AI宿舍推荐页面
    @GetMapping("/ai/recommend")
    public String toAiRecommend() {
        return "admin/ai/recommend";
    }
    
    // AI宿舍推荐处理
    @PostMapping("/ai/recommend")
    public String aiRecommend(@RequestParam("studentId") Integer studentId,
                               @RequestParam(value = "remark", required = false) String remark,
                               Model model) {
        // 调用AI推荐服务
        RecommendationResult result = aiService.getDormitoryRecommendation(studentId, remark);
        model.addAttribute("recommendation", result.getText());
        if (result.getScores() != null) {
            model.addAttribute("scoresJson", JSON.toJSONString(result.getScores()));
        }
        return "admin/ai/recommend";
    }

    // 通知中心
    @GetMapping("/notifications")
    public String notifications(Model model) {
        model.addAttribute("role", "admin");

        int pendingRepairs = repairRequestService.countPending();
        model.addAttribute("pendingRepairs", pendingRepairs);

        List<DormitoryTransfer> pendingTransfers = dormitoryTransferService.findByStatus(0);
        model.addAttribute("pendingTransfers", pendingTransfers != null ? pendingTransfers.size() : 0);

        List<DormitoryAllocation> recentAllocations = dormitoryAllocationService.findRecent(10);
        model.addAttribute("recentAllocations", recentAllocations);

        return "common/notifications";
    }

    // 帮助中心
    @GetMapping("/help")
    public String help(Model model) {
        model.addAttribute("role", "admin");
        return "common/help";
    }

    // 设置页面
    @GetMapping("/settings")
    public String toSettings(Model model) {
        model.addAttribute("role", "admin");
        return "common/settings";
    }

    // 修改密码
    @PostMapping("/settings")
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 HttpSession session, Model model) {
        model.addAttribute("role", "admin");

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (!user.getPassword().equals(oldPassword)) {
            model.addAttribute("error", "旧密码不正确");
            return "common/settings";
        }

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "两次输入的新密码不一致");
            return "common/settings";
        }

        if (newPassword.length() < 1) {
            model.addAttribute("error", "新密码不能为空");
            return "common/settings";
        }

        user.setPassword(newPassword);
        userService.updateUser(user);
        session.setAttribute("user", user);
        model.addAttribute("success", "密码修改成功");
        return "common/settings";
    }

    // 个人资料
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            model.addAttribute("user", user);
        }
        return "admin/profile";
    }
}