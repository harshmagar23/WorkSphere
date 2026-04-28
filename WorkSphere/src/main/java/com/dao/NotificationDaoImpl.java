package com.dao;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.model.NotificationModel;

@Repository
@Transactional
public class NotificationDaoImpl implements NotificationDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveNotification(NotificationModel notification) {
        sessionFactory.getCurrentSession().save(notification);
    }

    @Override
    public List<NotificationModel> getNotificationsByUser(int userId, String userType) {
        String hql = "from NotificationModel where userId = :userId and userType = :userType order by id desc";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, NotificationModel.class)
                .setParameter("userId", userId)
                .setParameter("userType", userType)
                .getResultList();
    }

    @Override
    public long getUnreadCount(int userId, String userType) {
        String hql = "select count(*) from NotificationModel where userId = :userId and userType = :userType and isRead = :isRead";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("userId", userId)
                .setParameter("userType", userType)
                .setParameter("isRead", "No")
                .uniqueResult();

        return count == null ? 0 : count;
    }

    @Override
    public void markAllAsRead(int userId, String userType) {
        String hql = "update NotificationModel set isRead = :readValue where userId = :userId and userType = :userType and isRead = :unreadValue";
        sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("readValue", "Yes")
                .setParameter("userId", userId)
                .setParameter("userType", userType)
                .setParameter("unreadValue", "No")
                .executeUpdate();
    }
}