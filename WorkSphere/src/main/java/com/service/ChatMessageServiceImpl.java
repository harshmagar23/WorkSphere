package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.ChatMessageDao;
import com.model.ChatMessageModel;

@Service
public class ChatMessageServiceImpl implements ChatMessageService {

    @Autowired
    private ChatMessageDao chatMessageDao;

    @Override
    @Transactional
    public void saveMessage(ChatMessageModel message) {
        chatMessageDao.saveMessage(message);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ChatMessageModel> getMessagesByProjectId(int projectId) {
        return chatMessageDao.getMessagesByProjectId(projectId);
    }

    @Override
    @Transactional(readOnly = true)
    public long countUnreadMessages(int projectId, String receiverType, int receiverId) {
        return chatMessageDao.countUnreadMessages(projectId, receiverType, receiverId);
    }

    @Override
    @Transactional
    public void markMessagesAsRead(int projectId, String receiverType, int receiverId) {
        chatMessageDao.markMessagesAsRead(projectId, receiverType, receiverId);
    }
}
