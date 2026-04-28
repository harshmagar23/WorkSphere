package com.service;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired(required = false)
    private JavaMailSenderImpl mailSender;

    private boolean isMailConfigured() {
        if (mailSender == null) {
            return false;
        }

        String username = mailSender.getUsername();
        String password = mailSender.getPassword();

        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        if (password == null || password.trim().isEmpty()) {
            return false;
        }

        if (username.contains("your-workspace-email") || password.contains("your-gmail-app-password")) {
            return false;
        }

        return true;
    }

    private String safe(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private boolean sendHtmlEmail(String toEmail, String subject, String htmlBody) {
        if (!isMailConfigured()) {
            return false;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(mailSender.getUsername(), "WorkSphere");
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);

            mailSender.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean sendClientRegistrationSuccessEmail(String toEmail, String name) {
        String userName = safe(name == null || name.trim().isEmpty() ? "Client" : name.trim());

        String html = "" +
                "<div style='font-family:Arial,sans-serif;background:#f6f8fb;padding:28px;'>" +
                "  <div style='max-width:620px;margin:auto;background:#ffffff;border-radius:18px;padding:30px;border:1px solid #e5e7eb;'>" +
                "    <h2 style='margin:0 0 12px;color:#0f172a;'>Welcome to WorkSphere, " + userName + "!</h2>" +
                "    <p style='color:#475569;line-height:1.7;font-size:15px;'>Your client account has been created successfully.</p>" +
                "    <p style='color:#475569;line-height:1.7;font-size:15px;'>You can now log in, post projects, review freelancer bids, chat with assigned freelancers, request revisions, and complete projects.</p>" +
                "    <div style='margin:24px 0;padding:16px;border-radius:14px;background:#eff6ff;color:#1d4ed8;font-weight:700;'>Account type: Client</div>" +
                "    <p style='color:#64748b;font-size:13px;line-height:1.6;'>If you did not create this account, please ignore this email.</p>" +
                "    <p style='margin-top:24px;color:#0f172a;font-weight:700;'>Regards,<br>WorkSphere Team</p>" +
                "  </div>" +
                "</div>";

        return sendHtmlEmail(toEmail, "Welcome to WorkSphere - Client Account Created", html);
    }

    @Override
    public boolean sendFreelancerRegistrationSuccessEmail(String toEmail, String name) {
        String userName = safe(name == null || name.trim().isEmpty() ? "Freelancer" : name.trim());

        String html = "" +
                "<div style='font-family:Arial,sans-serif;background:#f6f8fb;padding:28px;'>" +
                "  <div style='max-width:620px;margin:auto;background:#ffffff;border-radius:18px;padding:30px;border:1px solid #e5e7eb;'>" +
                "    <h2 style='margin:0 0 12px;color:#0f172a;'>Welcome to WorkSphere, " + userName + "!</h2>" +
                "    <p style='color:#475569;line-height:1.7;font-size:15px;'>Your freelancer account has been created successfully.</p>" +
                "    <p style='color:#475569;line-height:1.7;font-size:15px;'>You can now explore projects, submit bids, chat with clients, upload final work, and manage revisions.</p>" +
                "    <div style='margin:24px 0;padding:16px;border-radius:14px;background:#eff6ff;color:#1d4ed8;font-weight:700;'>Account type: Freelancer</div>" +
                "    <p style='color:#64748b;font-size:13px;line-height:1.6;'>If you did not create this account, please ignore this email.</p>" +
                "    <p style='margin-top:24px;color:#0f172a;font-weight:700;'>Regards,<br>WorkSphere Team</p>" +
                "  </div>" +
                "</div>";

        return sendHtmlEmail(toEmail, "Welcome to WorkSphere - Freelancer Account Created", html);
    }
}
