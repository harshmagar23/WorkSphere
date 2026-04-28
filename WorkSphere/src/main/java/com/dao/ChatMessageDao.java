package com.dao;

import java.util.List;

import com.model.ChatMessageModel;

public interface ChatMessageDao {

    public void saveMessage(ChatMessageModel message);

    public List<ChatMessageModel> getMessagesByProjectId(int projectId);

    public long countUnreadMessages(int projectId, String receiverType, int receiverId);

    public void markMessagesAsRead(int projectId, String receiverType, int receiverId);
}
