package com.sushepro.service;

import com.sushepro.pojo.User;

public interface UserService {
    // 用户登录
    User login(String username, String password);
    
    // 根据ID查询用户
    User findById(Integer id);
    
    // 添加用户
    int addUser(User user);
    
    // 更新用户
    int updateUser(User user);
    
    // 删除用户
    int deleteUser(Integer id);
}