package com.sushepro.controller;

import com.sushepro.pojo.Dormitory;
import com.sushepro.pojo.HabitQuestionnaire;
import com.sushepro.pojo.Student;
import com.sushepro.pojo.User;
import com.sushepro.pojo.DormitoryTransfer;
import com.sushepro.pojo.RepairRequest;
import com.sushepro.service.DormitoryService;
import com.sushepro.service.HabitQuestionnaireService;
import com.sushepro.service.StudentService;
import com.sushepro.service.DormitoryAllocationService;
import com.sushepro.service.DormitoryTransferService;
import com.sushepro.service.RepairRequestService;
import com.sushepro.service.UserService;
import com.sushepro.pojo.DormitoryAllocation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
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
    
    // 学生首页
    @GetMapping("/index")
    public String index(HttpSession session, Model model) {
        // 从session中获取当前登录用户
        User user = (User) session.getAttribute("user");

        if (user != null) {
            // 查询学生信息
            Student student = studentService.findByUserId(user.getId());
            model.addAttribute("student", student);

            if (student != null) {
                // 宿舍分配信息
                DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
                model.addAttribute("allocation", allocation);

                // 报修列表
                List<RepairRequest> repairList = repairRequestService.findByStudentId(student.getId());
                model.addAttribute("repairList", repairList);
                int pendingRepairs = 0;
                if (repairList != null) {
                    for (RepairRequest r : repairList) {
                        if (r.getStatus() != null && r.getStatus() == 2) pendingRepairs++;
                    }
                }
                model.addAttribute("pendingRepairs", pendingRepairs);
                int totalRepairs = repairList != null ? repairList.size() : 0;
                model.addAttribute("totalRepairs", totalRepairs);

                // 调换列表
                List<DormitoryTransfer> transferList = dormitoryTransferService.findByStudentId(student.getId());
                model.addAttribute("transferList", transferList);
                DormitoryTransfer latestTransfer = null;
                if (transferList != null && !transferList.isEmpty()) {
                    latestTransfer = transferList.get(0);
                }
                model.addAttribute("latestTransfer", latestTransfer);

                // 问卷状态
                HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());
                model.addAttribute("hasQuestionnaire", questionnaire != null);

                // 构建最近活动
                List<Map<String, Object>> activities = new ArrayList<>();
                Date now = new Date();

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

                activities.sort((a, b) -> ((Date) b.get("time")).compareTo((Date) a.get("time")));
                model.addAttribute("recentActivities", activities);
            }
        }

        return "student/index";
    }
    
    // 查看个人信息
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        // 从session中获取当前登录用户
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            // 查询学生信息
            Student student = studentService.findByUserId(user.getId());
            model.addAttribute("student", student);
        }
        
        return "student/profile";
    }
    
    // 跳转到生活习惯问卷页面
    @GetMapping("/habitQuestionnaire")
    public String toHabitQuestionnaire(HttpSession session, Model model) {
        // 从session中获取当前登录用户
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            // 查询学生信息
            Student student = studentService.findByUserId(user.getId());
            
            // 查询学生是否已经提交过问卷
            HabitQuestionnaire questionnaire = habitQuestionnaireService.findByStudentId(student.getId());
            model.addAttribute("questionnaire", questionnaire);
        }
        
        return "student/habitQuestionnaire";
    }
    
    // 提交生活习惯问卷
    @PostMapping("/habitQuestionnaire")
    public String submitHabitQuestionnaire(HabitQuestionnaire questionnaire, HttpSession session) {
        // 从session中获取当前登录用户
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            // 查询学生信息
            Student student = studentService.findByUserId(user.getId());
            
            // 设置学生ID
            questionnaire.setStudentId(student.getId());
            
            // 提交问卷
            habitQuestionnaireService.submitQuestionnaire(questionnaire);
        }
        
        // 跳转到学生首页
        return "redirect:/student/index";
    }
    
    // 查看宿舍分配信息
    @GetMapping("/dormitoryAllocation")
    public String dormitoryAllocation(HttpSession session, Model model) {
        // 从session中获取当前登录用户
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            // 查询学生信息
            Student student = studentService.findByUserId(user.getId());
            
            // 查询宿舍分配信息
            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            model.addAttribute("allocation", allocation);
        }
        
        return "student/dormitoryAllocation";
    }

    // 宿舍调换申请页面
    @GetMapping("/transfer")
    public String toTransfer(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            Student student = studentService.findByUserId(user.getId());
            model.addAttribute("student", student);

            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            model.addAttribute("allocation", allocation);

            List<Dormitory> dormitoryList = dormitoryService.findAll();
            model.addAttribute("dormitoryList", dormitoryList);

            List<DormitoryTransfer> transferList = dormitoryTransferService.findByStudentId(student.getId());
            model.addAttribute("transferList", transferList);
        }
        return "student/dormitoryTransfer";
    }

    // 提交宿舍调换申请
    @PostMapping("/transfer")
    public String submitTransfer(@RequestParam("reason") String reason,
                                 @RequestParam(value = "targetDormitoryId", required = false) Integer targetDormitoryId,
                                 @RequestParam(value = "attachment", required = false) MultipartFile attachment,
                                 HttpSession session,
                                 HttpServletRequest request) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            Student student = studentService.findByUserId(user.getId());

            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            if (allocation == null) {
                return "redirect:/student/dormitoryAllocation";
            }

            DormitoryTransfer transfer = new DormitoryTransfer();
            transfer.setStudentId(student.getId());
            transfer.setCurrentDormitoryId(allocation.getDormitoryId());
            transfer.setTargetDormitoryId(targetDormitoryId);
            transfer.setReason(reason);

            if (attachment != null && !attachment.isEmpty()) {
                String uploadDir = request.getServletContext().getRealPath("/") + "uploads" + File.separator + "transfer";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                String originalName = attachment.getOriginalFilename();
                String ext = originalName != null && originalName.contains(".") ?
                        originalName.substring(originalName.lastIndexOf(".")) : "";
                String savedName = UUID.randomUUID().toString() + ext;
                try {
                    attachment.transferTo(new File(dir, savedName));
                    transfer.setAttachment("uploads/transfer/" + savedName);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            dormitoryTransferService.submitTransfer(transfer);
        }
        return "redirect:/student/transfer";
    }

    // 报修申请页面
    @GetMapping("/repair")
    public String toRepair(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            Student student = studentService.findByUserId(user.getId());
            model.addAttribute("student", student);

            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            model.addAttribute("allocation", allocation);

            List<RepairRequest> repairList = repairRequestService.findByStudentId(student.getId());
            model.addAttribute("repairList", repairList);
        }
        return "student/repair";
    }

    // 提交报修申请
    @PostMapping("/repair")
    public String submitRepair(@RequestParam("description") String description,
                               @RequestParam(value = "image", required = false) MultipartFile image,
                               HttpSession session,
                               HttpServletRequest request) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            Student student = studentService.findByUserId(user.getId());

            RepairRequest repair = new RepairRequest();
            repair.setStudentId(student.getId());
            repair.setDescription(description);

            DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
            if (allocation != null) {
                repair.setDormitoryId(allocation.getDormitoryId());
            }

            if (image != null && !image.isEmpty()) {
                String uploadDir = request.getServletContext().getRealPath("/") + "uploads" + File.separator + "repair";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                String originalName = image.getOriginalFilename();
                String ext = originalName != null && originalName.contains(".") ?
                        originalName.substring(originalName.lastIndexOf(".")) : "";
                String savedName = UUID.randomUUID().toString() + ext;
                try {
                    image.transferTo(new File(dir, savedName));
                    repair.setImage("uploads/repair/" + savedName);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            repairRequestService.submitRepair(repair);
        }
        return "redirect:/student/repair";
    }

    // AI客服页面
    @GetMapping("/aiChat")
    public String aiChat(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");

        if (user != null) {
            Student student = studentService.findByUserId(user.getId());
            model.addAttribute("student", student);

            @SuppressWarnings("unchecked")
            List<Map<String, String>> chatHistory =
                (List<Map<String, String>>) session.getAttribute("chatHistory");
            model.addAttribute("chatHistory", chatHistory != null ? chatHistory : new ArrayList<>());
        }

        return "student/aiChat";
    }

    // 通知中心
    @GetMapping("/notifications")
    public String notifications(HttpSession session, Model model) {
        model.addAttribute("role", "student");

        User user = (User) session.getAttribute("user");
        if (user != null) {
            Student student = studentService.findByUserId(user.getId());
            if (student != null) {
                List<RepairRequest> repairList = repairRequestService.findByStudentId(student.getId());
                model.addAttribute("repairList", repairList);

                List<DormitoryTransfer> transferList = dormitoryTransferService.findByStudentId(student.getId());
                model.addAttribute("transferList", transferList);

                DormitoryAllocation allocation = dormitoryAllocationService.findByStudentId(student.getId());
                model.addAttribute("allocation", allocation);
            }
        }
        return "common/notifications";
    }

    // 帮助中心
    @GetMapping("/help")
    public String help(Model model) {
        model.addAttribute("role", "student");
        return "common/help";
    }

    // 设置页面
    @GetMapping("/settings")
    public String toSettings(Model model) {
        model.addAttribute("role", "student");
        return "common/settings";
    }

    // 修改密码
    @PostMapping("/settings")
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 HttpSession session, Model model) {
        model.addAttribute("role", "student");

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
}