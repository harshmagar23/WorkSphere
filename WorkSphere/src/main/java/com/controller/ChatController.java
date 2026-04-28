package com.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.model.ChatMessageModel;
import com.model.ClientModel;
import com.model.FreelancerModel;
import com.model.NotificationModel;
import com.model.ProjectModel;
import com.service.ChatMessageService;
import com.service.NotificationService;
import com.service.ProjectService;

@Controller
public class ChatController {

    @Autowired
    private ProjectService projectService;

    @Autowired
    private ChatMessageService chatMessageService;

    @Autowired
    private NotificationService notificationService;

    private String now() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    private String safeText(String value) {
        if (value == null) {
            return "";
        }

        String text = value.trim();

        if (text.length() > 3000) {
            text = text.substring(0, 3000);
        }

        return text;
    }

    private boolean hasClientAccess(ProjectModel project, ClientModel client) {
        return project != null
                && client != null
                && project.getClient() != null
                && project.getClient().getId() == client.getId();
    }

    private boolean hasFreelancerAccess(ProjectModel project, FreelancerModel freelancer) {
        return project != null
                && freelancer != null
                && project.getAssignedFreelancer() != null
                && project.getAssignedFreelancer().getId() == freelancer.getId();
    }

    @GetMapping("/projectChat")
    public String projectChat(@RequestParam("projectId") int projectId,
                              HttpSession session,
                              Model model) {

        ProjectModel project = projectService.getProjectById(projectId);

        if (project == null) {
            return "redirect:/";
        }

        ClientModel client = (ClientModel) session.getAttribute("clientSession");
        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        String currentUserType = null;
        int currentUserId = 0;
        String currentUserName = "";
        String backLink = "";

        if (hasClientAccess(project, client)) {
            currentUserType = "CLIENT";
            currentUserId = client.getId();
            currentUserName = client.getName();
            backLink = "viewMyProjects";
        } else if (hasFreelancerAccess(project, freelancer)) {
            currentUserType = "FREELANCER";
            currentUserId = freelancer.getId();
            currentUserName = freelancer.getName();
            backLink = "freelancerAssignedProjects";
        } else {
            if (client != null) {
                return "redirect:/viewMyProjects";
            }
            if (freelancer != null) {
                return "redirect:/freelancerAssignedProjects";
            }
            return "redirect:/clientLogin";
        }

        if (project.getAssignedFreelancer() == null) {
            if ("CLIENT".equals(currentUserType)) {
                return "redirect:/viewMyProjects";
            }
            return "redirect:/freelancerAssignedProjects";
        }

        chatMessageService.markMessagesAsRead(projectId, currentUserType, currentUserId);

        List<ChatMessageModel> messages = chatMessageService.getMessagesByProjectId(projectId);

        model.addAttribute("project", project);
        model.addAttribute("messages", messages);
        model.addAttribute("currentUserType", currentUserType);
        model.addAttribute("currentUserId", currentUserId);
        model.addAttribute("currentUserName", currentUserName);
        model.addAttribute("backLink", backLink);

        return "projectChat";
    }

    @PostMapping("/sendProjectMessage")
    public String sendProjectMessage(@RequestParam("projectId") int projectId,
                                     @RequestParam("message") String message,
                                     HttpSession session) {

        ProjectModel project = projectService.getProjectById(projectId);

        if (project == null) {
            return "redirect:/";
        }

        if (project.getAssignedFreelancer() == null) {
            return "redirect:/viewMyProjects";
        }

        ClientModel client = (ClientModel) session.getAttribute("clientSession");
        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        String cleanMessage = safeText(message);

        if (cleanMessage.length() == 0) {
            return "redirect:/projectChat?projectId=" + projectId;
        }

        ChatMessageModel chat = new ChatMessageModel();
        chat.setProject(project);
        chat.setMessage(cleanMessage);
        chat.setCreatedAt(now());
        chat.setIsRead("No");

        String notificationReceiverType = null;
        int notificationReceiverId = 0;
        String notificationMessage = "";

        if (hasClientAccess(project, client)) {
            chat.setSenderId(client.getId());
            chat.setSenderType("CLIENT");
            chat.setSenderName(client.getName());

            chat.setReceiverId(project.getAssignedFreelancer().getId());
            chat.setReceiverType("FREELANCER");
            chat.setReceiverName(project.getAssignedFreelancer().getName());

            notificationReceiverType = "FREELANCER";
            notificationReceiverId = project.getAssignedFreelancer().getId();
            notificationMessage = "New client message on project: " + project.getTitle();

        } else if (hasFreelancerAccess(project, freelancer)) {
            chat.setSenderId(freelancer.getId());
            chat.setSenderType("FREELANCER");
            chat.setSenderName(freelancer.getName());

            chat.setReceiverId(project.getClient().getId());
            chat.setReceiverType("CLIENT");
            chat.setReceiverName(project.getClient().getName());

            notificationReceiverType = "CLIENT";
            notificationReceiverId = project.getClient().getId();
            notificationMessage = "New freelancer message on project: " + project.getTitle();

        } else {
            if (client != null) {
                return "redirect:/viewMyProjects";
            }
            if (freelancer != null) {
                return "redirect:/freelancerAssignedProjects";
            }
            return "redirect:/clientLogin";
        }

        chatMessageService.saveMessage(chat);

        NotificationModel notification = new NotificationModel();
        notification.setUserId(notificationReceiverId);
        notification.setUserType(notificationReceiverType);
        notification.setMessage(notificationMessage);
        notification.setIsRead("No");
        notification.setCreatedAt(now());
        notificationService.saveNotification(notification);

        return "redirect:/projectChat?projectId=" + projectId;
    }
}
