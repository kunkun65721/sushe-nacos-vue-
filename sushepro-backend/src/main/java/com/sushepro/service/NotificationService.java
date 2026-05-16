package com.sushepro.service;

import com.sushepro.pojo.Notification;

import java.util.List;

public interface NotificationService {
    Notification findById(Integer id);

    List<Notification> findActiveByUserId(Integer userId);

    int createNotification(Notification notification);

    int markAsRead(Integer id);

    int markAsDeleted(Integer id);

    int markAsDeletedByReference(String referenceType, Integer referenceId);

    int countUnread(Integer userId);

    int countActive(Integer userId);
}
