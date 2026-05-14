package com.sushepro.service;

import com.sushepro.pojo.HabitQuestionnaire;

import java.util.List;

public interface HabitQuestionnaireService {
    // 根据ID查询问卷
    HabitQuestionnaire findById(Integer id);
    
    // 根据学生ID查询问卷
    HabitQuestionnaire findByStudentId(Integer studentId);
    
    // 提交问卷（添加或更新）
    int submitQuestionnaire(HabitQuestionnaire habitQuestionnaire);
    
    // 更新问卷
    int updateQuestionnaire(HabitQuestionnaire habitQuestionnaire);
    
    // 删除问卷
    int deleteQuestionnaire(Integer id);

    // 统计待处理问卷数（未提交问卷的学生数）
    int countPending();

    // 查询最近提交的问卷
    List<HabitQuestionnaire> findRecent(int limit);
}