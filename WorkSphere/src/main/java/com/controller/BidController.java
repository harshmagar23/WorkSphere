package com.controller;

import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.model.BidModel;
import com.model.ClientModel;
import com.model.FreelancerModel;
import com.model.NotificationModel;
import com.model.PaymentModel;
import com.model.ProjectModel;
import com.service.BidService;
import com.service.NotificationService;
import com.service.PaymentService;
import com.service.ProjectService;

@Controller
public class BidController {

    @Autowired
    private BidService bidService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private PaymentService paymentService;

    private String cleanText(String value, int maxLength) {
        if (value == null) {
            return "";
        }

        String text = value.trim();

        if (maxLength > 0 && text.length() > maxLength) {
            text = text.substring(0, maxLength);
        }

        return text;
    }

    private boolean isClientOwner(ProjectModel project, ClientModel client) {
        return project != null
                && client != null
                && project.getClient() != null
                && project.getClient().getId() == client.getId();
    }

    private boolean isOpen(ProjectModel project) {
        return project != null && "Open".equalsIgnoreCase(project.getStatus());
    }

    private boolean isPending(BidModel bid) {
        return bid != null && "Pending".equalsIgnoreCase(bid.getStatus());
    }

    private boolean isFreelancerOwner(BidModel bid, FreelancerModel freelancer) {
        return bid != null
                && freelancer != null
                && bid.getFreelancer() != null
                && bid.getFreelancer().getId() == freelancer.getId();
    }

    private void notifyUser(int userId, String userType, String message) {
        NotificationModel notification = new NotificationModel();
        notification.setUserId(userId);
        notification.setUserType(userType);
        notification.setMessage(message);
        notification.setIsRead("No");
        notification.setCreatedAt(LocalDateTime.now().toString());
        notificationService.saveNotification(notification);
    }


    private void createMockEscrowPayment(ProjectModel project, BidModel selectedBid, ClientModel client) {
        if (project == null || selectedBid == null || client == null || selectedBid.getFreelancer() == null) {
            return;
        }

        PaymentModel existingPayment = paymentService.getPaymentByProjectId(project.getId());
        if (existingPayment != null) {
            return;
        }

        double bidAmount = selectedBid.getBidAmount();
        double platformFee = paymentService.calculatePlatformFee(bidAmount);
        double totalAmount = paymentService.calculateTotalAmount(bidAmount);

        PaymentModel payment = new PaymentModel();
        payment.setProject(project);
        payment.setBid(selectedBid);
        payment.setClient(client);
        payment.setFreelancer(selectedBid.getFreelancer());
        payment.setBidAmount(bidAmount);
        payment.setPlatformFee(platformFee);
        payment.setTotalAmount(totalAmount);
        payment.setFreelancerAmount(bidAmount);
        payment.setPaymentStatus("Unpaid");
        payment.setPaymentMethod("Mock Escrow");
        payment.setCreatedAt(LocalDateTime.now().toString());
        payment.setUpdatedAt(LocalDateTime.now().toString());

        paymentService.savePayment(payment);
    }

    private String redirectToProjectBidsOrMyProjects(BidModel bid) {
        if (bid != null && bid.getProject() != null) {
            return "redirect:/viewProjectBids?projectId=" + bid.getProject().getId();
        }

        return "redirect:/viewMyProjects";
    }

    @GetMapping("/applyBidPage")
    public String openApplyBidPage(@RequestParam("projectId") int projectId,
                                   HttpSession session,
                                   Model model) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isOpen(project)) {
            return "redirect:/viewAllProjects";
        }

        BidModel existingBid = bidService.getBidByProjectAndFreelancer(projectId, freelancer.getId());
        if (existingBid != null) {
            model.addAttribute("error", "You already have an active proposal for this project.");
            return "redirect:/myProposals";
        }

        model.addAttribute("project", project);

        return "applyBid";
    }

    @PostMapping("/saveBid")
    public String saveBid(@RequestParam("projectId") int projectId,
                          @RequestParam("bidAmount") double bidAmount,
                          @RequestParam("proposalText") String proposalText,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isOpen(project)) {
            redirectAttributes.addFlashAttribute("warning", "This project is no longer open for proposals.");
            return "redirect:/viewAllProjects";
        }

        String cleanProposal = cleanText(proposalText, 3000);

        if (bidAmount <= 0) {
            redirectAttributes.addFlashAttribute("warning", "Please enter a valid bid amount.");
            return "redirect:/applyBidPage?projectId=" + projectId;
        }

        if (cleanProposal.length() < 20) {
            redirectAttributes.addFlashAttribute("warning", "Please write a proposal of at least 20 characters.");
            return "redirect:/applyBidPage?projectId=" + projectId;
        }

        BidModel existingBid = bidService.getBidByProjectAndFreelancer(projectId, freelancer.getId());
        if (existingBid != null) {
            redirectAttributes.addFlashAttribute("warning", "You already have an active proposal for this project.");
            return "redirect:/myProposals";
        }

        BidModel bid = new BidModel();
        bid.setBidAmount(bidAmount);
        bid.setProposalText(cleanProposal);
        bid.setStatus("Pending");
        bid.setUpdatedAt(LocalDateTime.now().toString());
        bid.setFreelancer(freelancer);
        bid.setProject(project);

        bidService.saveBid(bid);

        if (project.getClient() != null) {
            notifyUser(project.getClient().getId(), "CLIENT", "New bid received from " + freelancer.getName() + " on project: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Proposal submitted successfully. You can track it from My Proposals.");
        return "redirect:/myProposals";
    }


    @GetMapping("/editProposalPage")
    public String editProposalPage(@RequestParam("bidId") int bidId,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        BidModel bid = bidService.getBidById(bidId);

        if (!isFreelancerOwner(bid, freelancer)) {
            redirectAttributes.addFlashAttribute("error", "You can edit only your own proposal.");
            return "redirect:/myProposals";
        }

        if (!isPending(bid)) {
            redirectAttributes.addFlashAttribute("warning", "Only pending proposals can be edited.");
            return "redirect:/myProposals";
        }

        if (!isOpen(bid.getProject())) {
            redirectAttributes.addFlashAttribute("warning", "This project is no longer open, so the proposal cannot be edited.");
            return "redirect:/myProposals";
        }

        model.addAttribute("bid", bid);
        return "editProposal";
    }

    @PostMapping("/updateProposal")
    public String updateProposal(@RequestParam("bidId") int bidId,
                                 @RequestParam("bidAmount") double bidAmount,
                                 @RequestParam("proposalText") String proposalText,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        BidModel bid = bidService.getBidById(bidId);

        if (!isFreelancerOwner(bid, freelancer)) {
            redirectAttributes.addFlashAttribute("error", "You can update only your own proposal.");
            return "redirect:/myProposals";
        }

        if (!isPending(bid)) {
            redirectAttributes.addFlashAttribute("warning", "Only pending proposals can be edited.");
            return "redirect:/myProposals";
        }

        if (!isOpen(bid.getProject())) {
            redirectAttributes.addFlashAttribute("warning", "This project is no longer open, so the proposal cannot be edited.");
            return "redirect:/myProposals";
        }

        String cleanProposal = cleanText(proposalText, 3000);

        if (bidAmount <= 0) {
            redirectAttributes.addFlashAttribute("warning", "Please enter a valid bid amount.");
            return "redirect:/editProposalPage?bidId=" + bidId;
        }

        if (cleanProposal.length() < 20) {
            redirectAttributes.addFlashAttribute("warning", "Please write a proposal of at least 20 characters.");
            return "redirect:/editProposalPage?bidId=" + bidId;
        }

        bid.setBidAmount(bidAmount);
        bid.setProposalText(cleanProposal);
        bid.setUpdatedAt(LocalDateTime.now().toString());

        bidService.updateBid(bid);

        ProjectModel project = bid.getProject();
        if (project != null && project.getClient() != null) {
            notifyUser(project.getClient().getId(), "CLIENT", "A freelancer updated their proposal for project: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Proposal updated successfully.");
        return "redirect:/myProposals";
    }

    @GetMapping("/withdrawProposal")
    public String withdrawProposalGet(@RequestParam("bidId") int bidId) {
        return "redirect:/myProposals";
    }

    @PostMapping("/withdrawProposal")
    public String withdrawProposal(@RequestParam("bidId") int bidId,
                                   @RequestParam(value = "withdrawalReason", required = false) String withdrawalReason,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        BidModel bid = bidService.getBidById(bidId);

        if (!isFreelancerOwner(bid, freelancer)) {
            redirectAttributes.addFlashAttribute("error", "You can withdraw only your own proposal.");
            return "redirect:/myProposals";
        }

        if (!isPending(bid)) {
            redirectAttributes.addFlashAttribute("warning", "Only pending proposals can be withdrawn.");
            return "redirect:/myProposals";
        }

        if (!isOpen(bid.getProject())) {
            redirectAttributes.addFlashAttribute("warning", "This project is no longer open, so the proposal cannot be withdrawn.");
            return "redirect:/myProposals";
        }

        String cleanReason = cleanText(withdrawalReason, 1000);
        if (cleanReason.length() == 0) {
            cleanReason = "Withdrawn by freelancer";
        }

        bid.setStatus("Withdrawn");
        bid.setWithdrawalReason(cleanReason);
        bid.setWithdrawnAt(LocalDateTime.now().toString());
        bid.setUpdatedAt(LocalDateTime.now().toString());

        bidService.updateBid(bid);

        ProjectModel project = bid.getProject();
        if (project != null && project.getClient() != null) {
            notifyUser(project.getClient().getId(), "CLIENT", freelancer.getName() + " withdrew their proposal from project: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Proposal withdrawn successfully.");
        return "redirect:/myProposals";
    }

@GetMapping("/myProposals")
    public String myProposals(@RequestParam(value = "q", required = false) String q,
                              @RequestParam(value = "status", required = false, defaultValue = "all") String status,
                              @RequestParam(value = "sort", required = false, defaultValue = "newest") String sort,
                              @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                              HttpSession session,
                              Model model) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        if (page < 1) {
            page = 1;
        }

        int pageSize = 8;

        status = normalizeStatusFilter(status);
        sort = normalizeSort(sort);

        long totalFiltered = bidService.countSearchBidsByFreelancer(freelancer.getId(), q, status);
        int totalPages = (int) Math.ceil(totalFiltered / (double) pageSize);

        if (totalPages < 1) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        List<BidModel> bids = bidService.searchBidsByFreelancer(
                freelancer.getId(),
                q,
                status,
                sort,
                page,
                pageSize
        );

        long totalBids = bidService.countBidsByFreelancer(freelancer.getId());
        long acceptedCount = bidService.countBidsByFreelancerAndStatus(freelancer.getId(), "accepted");
        long pendingCount = bidService.countBidsByFreelancerAndStatus(freelancer.getId(), "pending");
        long rejectedCount = bidService.countBidsByFreelancerAndStatus(freelancer.getId(), "rejected");
        long withdrawnCount = bidService.countBidsByFreelancerAndStatus(freelancer.getId(), "withdrawn");
        long unreadNotificationCount = notificationService.getUnreadCount(freelancer.getId(), "FREELANCER");

        model.addAttribute("bids", bids);
        model.addAttribute("q", q == null ? "" : q.trim());
        model.addAttribute("statusFilter", status);
        model.addAttribute("sort", sort);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalFiltered", totalFiltered);
        model.addAttribute("totalBids", totalBids);
        model.addAttribute("acceptedCount", acceptedCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("rejectedCount", rejectedCount);
        model.addAttribute("withdrawnCount", withdrawnCount);
        model.addAttribute("unreadNotificationCount", unreadNotificationCount);

        return "myProposals";
    }

    @GetMapping("/viewProjectBids")
    public String viewProjectBids(@RequestParam("projectId") int projectId,
                                  HttpSession session,
                                  Model model) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            return "redirect:/viewMyProjects";
        }

        List<BidModel> bids = bidService.getBidsByProjectId(projectId);

        model.addAttribute("project", project);
        model.addAttribute("bids", bids);

        return "viewProjectBids";
    }

    @GetMapping("/acceptBid")
    public String acceptBidGet(@RequestParam("bidId") int bidId) {
        BidModel bid = bidService.getBidById(bidId);
        return redirectToProjectBidsOrMyProjects(bid);
    }

    @PostMapping("/acceptBid")
    public String acceptBid(@RequestParam("bidId") int bidId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        BidModel selectedBid = bidService.getBidById(bidId);

        if (selectedBid == null) {
            return "redirect:/viewMyProjects";
        }

        ProjectModel project = selectedBid.getProject();

        if (!isClientOwner(project, client)) {
            return "redirect:/viewMyProjects";
        }

        if (!isOpen(project)) {
            return "redirect:/viewProjectBids?projectId=" + project.getId();
        }

        if (!isPending(selectedBid)) {
            return "redirect:/viewProjectBids?projectId=" + project.getId();
        }

        if (selectedBid.getFreelancer() == null) {
            return "redirect:/viewProjectBids?projectId=" + project.getId();
        }

        List<BidModel> allBids = bidService.getBidsByProjectId(project.getId());

        for (BidModel bid : allBids) {
            if (bid == null) {
                continue;
            }

            if (bid.getId() == bidId) {
                bid.setStatus("Accepted");
                bidService.updateBid(bid);

                if (bid.getFreelancer() != null) {
                    notifyUser(bid.getFreelancer().getId(), "FREELANCER", "Your bid was accepted for project: " + project.getTitle() + ". Waiting for client escrow funding.");
                }
            } else if (isPending(bid)) {
                bid.setStatus("Rejected");
                bidService.updateBid(bid);

                if (bid.getFreelancer() != null) {
                    notifyUser(bid.getFreelancer().getId(), "FREELANCER", "Your bid was rejected for project: " + project.getTitle());
                }
            }
        }

        project.setStatus("Payment Pending");
        project.setAssignedFreelancer(selectedBid.getFreelancer());
        projectService.updateProject(project);

        createMockEscrowPayment(project, selectedBid, client);

        redirectAttributes.addFlashAttribute("success", "Bid accepted. The project is now waiting for mock escrow funding.");
        return "redirect:/viewMyProjects";
    }

    @GetMapping("/rejectBid")
    public String rejectBidGet(@RequestParam("bidId") int bidId) {
        BidModel bid = bidService.getBidById(bidId);
        return redirectToProjectBidsOrMyProjects(bid);
    }

    @PostMapping("/rejectBid")
    public String rejectBid(@RequestParam("bidId") int bidId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        BidModel bid = bidService.getBidById(bidId);

        if (bid == null) {
            redirectAttributes.addFlashAttribute("error", "Bid was not found.");
            return "redirect:/viewMyProjects";
        }

        ProjectModel project = bid.getProject();

        if (!isClientOwner(project, client)) {
            return "redirect:/viewMyProjects";
        }

        if (!isOpen(project)) {
            return "redirect:/viewProjectBids?projectId=" + project.getId();
        }

        if (!isPending(bid)) {
            redirectAttributes.addFlashAttribute("warning", "Only pending bids can be rejected.");
            return "redirect:/viewProjectBids?projectId=" + project.getId();
        }

        bid.setStatus("Rejected");
        bidService.updateBid(bid);

        if (bid.getFreelancer() != null) {
            notifyUser(bid.getFreelancer().getId(), "FREELANCER", "Your bid was rejected for project: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Bid rejected successfully.");
        return "redirect:/viewProjectBids?projectId=" + project.getId();
    }

    private String normalizeStatusFilter(String status) {
        if (status == null) {
            return "all";
        }

        String s = status.trim().toLowerCase();

        if ("accepted".equals(s) || "pending".equals(s) || "rejected".equals(s) || "withdrawn".equals(s)) {
            return s;
        }

        return "all";
    }

    private String normalizeSort(String sort) {
        if (sort == null) {
            return "newest";
        }

        String s = sort.trim().toLowerCase();

        if ("amounthigh".equals(s) || "amountlow".equals(s) || "projectaz".equals(s) || "status".equals(s)) {
            return s;
        }

        return "newest";
    }
}
