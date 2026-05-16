package com.sushepro.mapper;

import com.sushepro.pojo.Notification;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface NotificationMapper {
    Notification findById(@Param("id") Integer id);

    List<Notification> findActiveByUserId(@Param("userId") Integer userId);

    int insert(Notification notification);

    int markAsRead(@Param("id") Integer id);

    int markAsDeleted(@Param("id") Integer id);

    int markAsDeletedByReference(@Param("referenceType") String referenceType,
                                  @Param("referenceId") Integer referenceId);

    int countUnread(@Param("userId") Integer userId);

    int countActive(@Param("userId") Integer userId);
}
