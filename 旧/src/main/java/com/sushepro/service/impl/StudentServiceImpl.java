package com.sushepro.service.impl;

import com.sushepro.mapper.StudentMapper;
import com.sushepro.pojo.Student;
import com.sushepro.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentServiceImpl implements StudentService {
    
    @Autowired
    private StudentMapper studentMapper;
    
    @Override
    public Student findById(Integer id) {
        return studentMapper.findById(id);
    }
    
    @Override
    public Student findByUserId(Integer userId) {
        return studentMapper.findByUserId(userId);
    }
    
    @Override
    public List<Student> findAll() {
        return studentMapper.findAll();
    }
    
    @Override
    public int addStudent(Student student) {
        return studentMapper.addStudent(student);
    }
    
    @Override
    public int updateStudent(Student student) {
        return studentMapper.updateStudent(student);
    }
    
    @Override
    public int deleteStudent(Integer id) {
        return studentMapper.deleteStudent(id);
    }

    @Override
    public int countAll() {
        return studentMapper.countAll();
    }
}