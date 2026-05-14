package com.sushepro.service;

import com.sushepro.pojo.Student;

import java.util.List;

public interface StudentService {
    // 根据ID查询学生
    Student findById(Integer id);
    
    // 根据用户ID查询学生
    Student findByUserId(Integer userId);
    
    // 查询所有学生
    List<Student> findAll();
    
    // 添加学生
    int addStudent(Student student);
    
    // 更新学生
    int updateStudent(Student student);
    
    // 删除学生
    int deleteStudent(Integer id);

    // 统计学生总数
    int countAll();
}