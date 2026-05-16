package com.sushepro.service.impl;

import com.sushepro.mapper.UserMapper;
import com.sushepro.pojo.User;
import com.sushepro.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Override
    public User login(String username, String password) {
        User user = userMapper.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
    
    @Override
    public User findById(Integer id) {
        return userMapper.findById(id);
    }
    
    @Override
    public int addUser(User user) {
        return userMapper.addUser(user);
    }
    
    @Override
    public int updateUser(User user) {
        return userMapper.updateUser(user);
    }
    
    @Override
    public int deleteUser(Integer id) {
        return userMapper.deleteUser(id);
    }

    @Override
    public List<User> findByRole(Integer role) {
        return userMapper.findByRole(role);
    }
}