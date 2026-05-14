package com.sushepro.mapper;

import com.sushepro.pojo.HabitQuestionnaire;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface HabitQuestionnaireMapper {
    // 根据ID查询问卷
    HabitQuestionnaire findById(Integer id);
    
    // 根据学生ID查询问卷
    HabitQuestionnaire findByStudentId(Integer studentId);
    
    // 添加问卷
    int addHabitQuestionnaire(HabitQuestionnaire habitQuestionnaire);
    
    // 更新问卷
    int updateHabitQuestionnaire(HabitQuestionnaire habitQuestionnaire);
    
    // 删除问卷
    int deleteHabitQuestionnaire(Integer id);

    // 统计待处理问卷数（未提交问卷的学生数）
    int countPending();

    // 查询最近提交的问卷（含学生姓名）
    List<HabitQuestionnaire> findRecent(@Param("limit") int limit);
}