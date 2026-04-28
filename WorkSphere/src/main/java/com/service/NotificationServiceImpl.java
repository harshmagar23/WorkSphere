package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.NotificationDao;
import com.model.NotificationModel;

@Service
@Transactional
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationDao notificationDao;

    @Override
    public void saveNotification(NotificationModel notification) {
        notificationDao.saveNotification(notification);
    }

    @Override
    public List<NotificationModel> getNotificationsByUser(int userId, String userType) {
        return notificationDao.getNotificationsByUser(userId, userType);
    }

    @Override
    public long getUnreadCount(int userId, String userType) {
        return notificationDao.getUnreadCount(userId, userType);
    }

    @Override
    public void markAllAsRead(int userId, String userType) {
        notificationDao.markAllAsRead(userId, userType);
    }
}