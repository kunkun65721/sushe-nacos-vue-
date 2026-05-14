package com.sushepro.mapper;

import com.sushepro.pojo.User;

public interface UserMapper {
    // 根据用户名查询用户
    User findByUsername(String username);
    
    // 根据ID查询用户
    User findById(Integer id);
    
    // 添加用户
    int addUser(User user);
    
    // 更新用户
    int updateUser(User user);
    
    // 删除用户
    int deleteUser(Integer id);
}