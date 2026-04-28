package com.service;

import java.util.List;
import com.model.NotificationModel;

public interface NotificationService {

    public void saveNotification(NotificationModel notification);

    public List<NotificationModel> getNotificationsByUser(int userId, String userType);

    public long getUnreadCount(int userId, String userType);

    public void markAllAsRead(int userId, String userType);
}