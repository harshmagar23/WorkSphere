package com.dao;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.model.ChatMessageModel;

@Repository
public class ChatMessageDaoImpl implements ChatMessageDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveMessage(ChatMessageModel message) {
        sessionFactory.getCurrentSession().save(message);
    }

    @Override
    public List<ChatMessageModel> getMessagesByProjectId(int projectId) {
        String hql = "from ChatMessageModel where project.id = :projectId order by id asc";

        return sessionFactory.getCurrentSession()
                .createQuery(hql, ChatMessageModel.class)
                .setParameter("projectId", projectId)
                .getResultList();
    }

    @Override
    public long countUnreadMessages(int projectId, String receiverType, int receiverId) {
        String hql = "select count(*) from ChatMessageModel "
                + "where project.id = :projectId "
                + "and receiverType = :receiverType "
                + "and receiverId = :receiverId "
                + "and isRead = :isRead";

        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("projectId", projectId)
                .setParameter("receiverType", receiverType)
                .setParameter("receiverId", receiverId)
                .setParameter("isRead", "No")
                .uniqueResult();

        return count == null ? 0 : count;
    }

    @Override
    public void markMessagesAsRead(int projectId, String receiverType, int receiverId) {
        String hql = "update ChatMessageModel set isRead = :yes "
                + "where project.id = :projectId "
                + "and receiverType = :receiverType "
                + "and receiverId = :receiverId";

        sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("yes", "Yes")
                .setParameter("projectId", projectId)
                .setParameter("receiverType", receiverType)
                .setParameter("receiverId", receiverId)
                .executeUpdate();
    }
}
