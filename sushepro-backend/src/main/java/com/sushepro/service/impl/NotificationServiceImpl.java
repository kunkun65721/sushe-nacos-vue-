package com.sushepro.service.impl;

import com.sushepro.mapper.NotificationMapper;
import com.sushepro.pojo.Notification;
import com.sushepro.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationMapper notificationMapper;

    @Override
    public Notification findById(Integer id) {
        return notificationMapper.findById(id);
    }

    @Override
    public List<Notification> findActiveByUserId(Integer userId) {
        return notificationMapper.findActiveByUserId(userId);
    }

    @Override
    public int createNotification(Notification notification) {
        return notificationMapper.insert(notification);
    }

    @Override
    public int markAsRead(Integer id) {
        return notificationMapper.markAsRead(id);
    }

    @Override
    public int markAsDeleted(Integer id) {
        return notificationMapper.markAsDeleted(id);
    }

    @Override
    public int markAsDeletedByReference(String referenceType, Integer referenceId) {
        return notificationMapper.markAsDeletedByReference(referenceType, referenceId);
    }

    @Override
    public int countUnread(Integer userId) {
        return notificationMapper.countUnread(userId);
    }

    @Override
    public int countActive(Integer userId) {
        return notificationMapper.countActive(userId);
    }
}
