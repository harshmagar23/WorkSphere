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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.model.ClientModel;
import com.model.FreelancerModel;
import com.model.NotificationModel;
import com.model.PaymentModel;
import com.model.ProjectModel;
import com.service.NotificationService;
import com.service.PaymentService;
import com.service.ProjectService;

@Controller
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private NotificationService notificationService;

    private boolean isClientOwner(ProjectModel project, ClientModel client) {
        return project != null && client != null && project.getClient() != null && project.getClient().getId() == client.getId();
    }

    private boolean isFreelancerOwner(PaymentModel payment, FreelancerModel freelancer) {
        return payment != null
                && freelancer != null
                && payment.getFreelancer() != null
                && payment.getFreelancer().getId() == freelancer.getId();
    }

    private boolean isClientPaymentOwner(PaymentModel payment, ClientModel client) {
        return payment != null
                && client != null
                && payment.getClient() != null
                && payment.getClient().getId() == client.getId();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String cleanText(String value, int maxLength) {
        if (value == null) return "";
        String cleaned = value.trim();
        if (cleaned.length() > maxLength) {
            cleaned = cleaned.substring(0, maxLength);
        }
        return cleaned;
    }

    private String now() {
        return LocalDateTime.now().toString();
    }

    private String generateTransactionId(int projectId) {
        String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "WS-MOCK-" + projectId + "-" + date;
    }

    private void notifyUser(int userId, String userType, String message) {
        NotificationModel notification = new NotificationModel();
        notification.setUserId(userId);
        notification.setUserType(userType);
        notification.setMessage(message);
        notification.setIsRead("No");
        notification.setCreatedAt(now());
        notificationService.saveNotification(notification);
    }

    @PostMapping("/fundProject")
    public String fundProject(@RequestParam("projectId") int projectId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to fund this project.");
            return "redirect:/viewMyProjects";
        }

        if (!"Payment Pending".equalsIgnoreCase(project.getStatus())) {
            redirectAttributes.addFlashAttribute("warning", "This project is not waiting for payment.");
            return "redirect:/viewMyProjects";
        }

        PaymentModel payment = paymentService.getPaymentByProjectId(projectId);

        if (payment == null) {
            redirectAttributes.addFlashAttribute("error", "Payment record was not found for this project.");
            return "redirect:/viewMyProjects";
        }

        if (!"Unpaid".equalsIgnoreCase(payment.getPaymentStatus())) {
            redirectAttributes.addFlashAttribute("warning", "This payment is already processed.");
            return "redirect:/viewMyProjects";
        }

        payment.setPaymentStatus("Escrow Funded");
        payment.setPaymentMethod("Mock Escrow Wallet");
        payment.setTransactionId(generateTransactionId(projectId));
        payment.setPaidAt(now());
        payment.setUpdatedAt(now());
        paymentService.updatePayment(payment);

        project.setStatus("In Progress");
        projectService.updateProject(project);

        if (project.getAssignedFreelancer() != null) {
            notifyUser(project.getAssignedFreelancer().getId(), "FREELANCER", "Project funded and ready to start: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Project funded successfully. Payment is now held in mock escrow and the freelancer can start work.");
        return "redirect:/viewMyProjects";
    }


    @PostMapping("/refundProject")
    public String refundProject(@RequestParam("projectId") int projectId,
                                @RequestParam(value = "refundReason", required = false) String refundReason,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to refund this project.");
            return "redirect:/clientPayments";
        }

        PaymentModel payment = paymentService.getPaymentByProjectId(projectId);

        if (payment == null) {
            redirectAttributes.addFlashAttribute("error", "Payment record was not found.");
            return "redirect:/clientPayments";
        }

        if (!"Escrow Funded".equalsIgnoreCase(payment.getPaymentStatus())) {
            redirectAttributes.addFlashAttribute("warning", "Only escrow-funded payments can be refunded from this action.");
            return "redirect:/clientPayments";
        }

        if (!"In Progress".equalsIgnoreCase(project.getStatus())) {
            redirectAttributes.addFlashAttribute("warning", "Refund is allowed only while the project is in progress and before work submission.");
            return "redirect:/clientPayments";
        }

        if (!isBlank(project.getSubmissionStoredFileName())) {
            redirectAttributes.addFlashAttribute("warning", "Refund is not allowed after the freelancer has submitted work. Use revision or completion flow instead.");
            return "redirect:/clientPayments";
        }

        String cleanReason = cleanText(refundReason, 1000);
        if (cleanReason.length() == 0) {
            cleanReason = "Refunded by client before work submission";
        }

        payment.setPaymentStatus("Refunded");
        payment.setRefundedAt(now());
        payment.setRefundReason(cleanReason);
        payment.setUpdatedAt(now());
        paymentService.updatePayment(payment);

        project.setStatus("Cancelled");
        project.setCancelledAt(now());
        project.setCancellationReason(cleanReason);
        project.setUpdatedAt(now());
        projectService.updateProject(project);

        if (project.getAssignedFreelancer() != null) {
            notifyUser(project.getAssignedFreelancer().getId(), "FREELANCER", "Client refunded and cancelled project before work submission: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Escrow payment refunded successfully and the project was cancelled.");
        return "redirect:/clientPayments";
    }

    @GetMapping("/paymentReceipt")
    public String paymentReceipt(@RequestParam("paymentId") int paymentId,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");
        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (client == null && freelancer == null) {
            return "redirect:/clientLogin";
        }

        PaymentModel payment = paymentService.getPaymentById(paymentId);

        boolean allowed = false;
        String backLink = "clientPayments";

        if (client != null && isClientPaymentOwner(payment, client)) {
            allowed = true;
            backLink = "clientPayments";
        }

        if (freelancer != null && isFreelancerOwner(payment, freelancer)) {
            allowed = true;
            backLink = "freelancerEarnings";
        }

        if (!allowed) {
            redirectAttributes.addFlashAttribute("error", "You are not allowed to view this payment receipt.");
            if (client != null) return "redirect:/clientPayments";
            return "redirect:/freelancerEarnings";
        }

        model.addAttribute("payment", payment);
        model.addAttribute("backLink", backLink);
        return "paymentReceipt";
    }

    @GetMapping("/clientPayments")
    public String clientPayments(HttpSession session, Model model) {
        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        List<PaymentModel> payments = paymentService.getPaymentsByClientId(client.getId());

        model.addAttribute("payments", payments);
        model.addAttribute("totalPayments", payments == null ? 0 : payments.size());
        model.addAttribute("unpaidCount", paymentService.countPaymentsByClientAndStatus(client.getId(), "Unpaid"));
        model.addAttribute("fundedCount", paymentService.countPaymentsByClientAndStatus(client.getId(), "Escrow Funded"));
        model.addAttribute("releasedCount", paymentService.countPaymentsByClientAndStatus(client.getId(), "Released"));
        model.addAttribute("refundedCount", paymentService.countPaymentsByClientAndStatus(client.getId(), "Refunded"));
        model.addAttribute("cancelledCount", paymentService.countPaymentsByClientAndStatus(client.getId(), "Cancelled"));

        return "clientPayments";
    }

    @GetMapping("/freelancerEarnings")
    public String freelancerEarnings(HttpSession session, Model model) {
        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        List<PaymentModel> payments = paymentService.getPaymentsByFreelancerId(freelancer.getId());

        model.addAttribute("payments", payments);
        model.addAttribute("totalPayments", payments == null ? 0 : payments.size());
        model.addAttribute("fundedCount", paymentService.countPaymentsByFreelancerAndStatus(freelancer.getId(), "Escrow Funded"));
        model.addAttribute("releasedCount", paymentService.countPaymentsByFreelancerAndStatus(freelancer.getId(), "Released"));
        model.addAttribute("releasedAmount", paymentService.sumFreelancerReleasedAmount(freelancer.getId()));
        model.addAttribute("refundedCount", paymentService.countPaymentsByFreelancerAndStatus(freelancer.getId(), "Refunded"));
        model.addAttribute("cancelledCount", paymentService.countPaymentsByFreelancerAndStatus(freelancer.getId(), "Cancelled"));

        return "freelancerEarnings";
    }
}
