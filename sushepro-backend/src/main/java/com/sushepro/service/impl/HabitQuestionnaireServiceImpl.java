package com.sushepro.service.impl;

import com.sushepro.mapper.HabitQuestionnaireMapper;
import com.sushepro.pojo.HabitQuestionnaire;
import com.sushepro.service.HabitQuestionnaireService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class HabitQuestionnaireServiceImpl implements HabitQuestionnaireService {
    
    @Autowired
    private HabitQuestionnaireMapper habitQuestionnaireMapper;
    
    @Override
    public HabitQuestionnaire findById(Integer id) {
        return habitQuestionnaireMapper.findById(id);
    }
    
    @Override
    public HabitQuestionnaire findByStudentId(Integer studentId) {
        return habitQuestionnaireMapper.findByStudentId(studentId);
    }
    
    @Override
    public int submitQuestionnaire(HabitQuestionnaire habitQuestionnaire) {
        // 检查学生是否已经提交过问卷
        HabitQuestionnaire existingQuestionnaire = habitQuestionnaireMapper.findByStudentId(habitQuestionnaire.getStudentId());
        
        habitQuestionnaire.setCreateTime(new Date());
        
        if (existingQuestionnaire != null) {
            // 已经提交过，更新问卷
            habitQuestionnaire.setId(existingQuestionnaire.getId());
            return habitQuestionnaireMapper.updateHabitQuestionnaire(habitQuestionnaire);
        } else {
            // 未提交过，添加新问卷
            return habitQuestionnaireMapper.addHabitQuestionnaire(habitQuestionnaire);
        }
    }
    
    @Override
    public int updateQuestionnaire(HabitQuestionnaire habitQuestionnaire) {
        return habitQuestionnaireMapper.updateHabitQuestionnaire(habitQuestionnaire);
    }
    
    @Override
    public int deleteQuestionnaire(Integer id) {
        return habitQuestionnaireMapper.deleteHabitQuestionnaire(id);
    }

    @Override
    public int countPending() {
        return habitQuestionnaireMapper.countPending();
    }

    @Override
    public List<HabitQuestionnaire> findRecent(int limit) {
        return habitQuestionnaireMapper.findRecent(limit);
    }
}