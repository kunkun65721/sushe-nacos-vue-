package com.sushepro.mapper;

import com.sushepro.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

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

    // 根据角色查询用户
    List<User> findByRole(@Param("role") Integer role);
}