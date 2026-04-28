package com.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.model.ClientModel;
import com.model.FreelancerModel;
import com.model.NotificationModel;
import com.model.PaymentModel;
import com.model.ProjectModel;
import com.service.NotificationService;
import com.service.PaymentService;
import com.service.ProjectService;
import com.service.SavedProjectService;

@Controller
public class ProjectController {

    private static final long MAX_SUBMISSION_FILE_SIZE = 50L * 1024L * 1024L;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private SavedProjectService savedProjectService;

    private Path getUploadRoot() throws IOException {
        Path root = Paths.get(System.getProperty("user.home"), "worksphere_uploads");
        Files.createDirectories(root);
        return root;
    }

    private String cleanFileName(String fileName) {
        String cleanName = StringUtils.cleanPath(fileName == null ? "file" : fileName);
        return cleanName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

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

    private boolean isAllowedFile(String fileName) {
        String cleanName = cleanFileName(fileName).toLowerCase();
        int dot = cleanName.lastIndexOf(".");

        if (dot == -1) {
            return false;
        }

        String extension = cleanName.substring(dot + 1);

        return Arrays.asList(
                "zip", "rar", "7z",
                "pdf",
                "doc", "docx",
                "ppt", "pptx",
                "xls", "xlsx",
                "png", "jpg", "jpeg",
                "txt"
        ).contains(extension);
    }

    private boolean isClientOwner(ProjectModel project, ClientModel client) {
        return project != null
                && client != null
                && project.getClient() != null
                && project.getClient().getId() == client.getId();
    }

    private boolean isAssignedFreelancer(ProjectModel project, FreelancerModel freelancer) {
        return project != null
                && freelancer != null
                && project.getAssignedFreelancer() != null
                && project.getAssignedFreelancer().getId() == freelancer.getId();
    }

    private boolean canSubmitWork(ProjectModel project) {
        if (project == null || project.getAssignedFreelancer() == null) {
            return false;
        }

        return "In Progress".equalsIgnoreCase(project.getStatus())
                || "Revision Requested".equalsIgnoreCase(project.getStatus());
    }

    private boolean canCancelProject(ProjectModel project) {
        if (project == null || project.getStatus() == null) {
            return false;
        }

        String status = project.getStatus();

        if ("Open".equalsIgnoreCase(status)) {
            return true;
        }

        if ("Payment Pending".equalsIgnoreCase(status)) {
            PaymentModel payment = paymentService.getPaymentByProjectId(project.getId());
            return payment == null || "Unpaid".equalsIgnoreCase(payment.getPaymentStatus());
        }

        return false;
    }


    private Map<Integer, PaymentModel> buildPaymentMap(List<ProjectModel> projects) {
        Map<Integer, PaymentModel> paymentMap = new HashMap<Integer, PaymentModel>();

        if (projects == null) {
            return paymentMap;
        }

        for (ProjectModel project : projects) {
            if (project == null) {
                continue;
            }

            PaymentModel payment = paymentService.getPaymentByProjectId(project.getId());
            if (payment != null) {
                paymentMap.put(project.getId(), payment);
            }
        }

        return paymentMap;
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

    @GetMapping("/postProjectPage")
    public String openPostProjectPage(HttpSession session) {
        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        return "postProject";
    }

    @PostMapping("/saveProject")
    public String saveProject(@RequestParam("title") String title,
                              @RequestParam("description") String description,
                              @RequestParam("budget") double budget,
                              @RequestParam("deadline") String deadline,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        String cleanTitle = cleanText(title, 255);
        String cleanDescription = cleanText(description, 2000);
        String cleanDeadline = cleanText(deadline, 60);

        if (cleanTitle.length() == 0 || cleanDescription.length() == 0 || cleanDeadline.length() == 0 || budget <= 0) {
            redirectAttributes.addFlashAttribute("warning", "Please fill all project details correctly before posting.");
            return "redirect:/postProjectPage";
        }

        ProjectModel project = new ProjectModel();
        project.setTitle(cleanTitle);
        project.setDescription(cleanDescription);
        project.setBudget(budget);
        project.setDeadline(cleanDeadline);
        project.setStatus("Open");
        project.setClient(client);
        project.setRevisionCount(0);
        project.setUpdatedAt(LocalDateTime.now().toString());

        projectService.saveProject(project);

        redirectAttributes.addFlashAttribute("success", "Project posted successfully. Freelancers can now send proposals.");
        return "redirect:/viewMyProjects";
    }


    @GetMapping("/editProjectPage")
    public String editProjectPage(@RequestParam("projectId") int projectId,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            redirectAttributes.addFlashAttribute("error", "You can edit only your own projects.");
            return "redirect:/viewMyProjects";
        }

        if (!"Open".equalsIgnoreCase(project.getStatus())) {
            redirectAttributes.addFlashAttribute("warning", "Only Open projects can be edited. Once a bid is accepted, the project is locked.");
            return "redirect:/viewMyProjects";
        }

        model.addAttribute("project", project);
        return "editProject";
    }

    @PostMapping("/updateProject")
    public String updateProject(@RequestParam("projectId") int projectId,
                                @RequestParam("title") String title,
                                @RequestParam("description") String description,
                                @RequestParam("budget") double budget,
                                @RequestParam("deadline") String deadline,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            redirectAttributes.addFlashAttribute("error", "You can update only your own projects.");
            return "redirect:/viewMyProjects";
        }

        if (!"Open".equalsIgnoreCase(project.getStatus())) {
            redirectAttributes.addFlashAttribute("warning", "Only Open projects can be edited.");
            return "redirect:/viewMyProjects";
        }

        String cleanTitle = cleanText(title, 255);
        String cleanDescription = cleanText(description, 2000);
        String cleanDeadline = cleanText(deadline, 60);

        if (cleanTitle.length() == 0 || cleanDescription.length() == 0 || cleanDeadline.length() == 0 || budget <= 0) {
            redirectAttributes.addFlashAttribute("warning", "Please fill all project details correctly before updating.");
            return "redirect:/editProjectPage?projectId=" + projectId;
        }

        project.setTitle(cleanTitle);
        project.setDescription(cleanDescription);
        project.setBudget(budget);
        project.setDeadline(cleanDeadline);
        project.setUpdatedAt(LocalDateTime.now().toString());

        projectService.updateProject(project);

        redirectAttributes.addFlashAttribute("success", "Project updated successfully.");
        return "redirect:/viewMyProjects";
    }

    @PostMapping("/cancelProject")
    public String cancelProject(@RequestParam("projectId") int projectId,
                                @RequestParam(value = "cancellationReason", required = false) String cancellationReason,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            redirectAttributes.addFlashAttribute("error", "You can cancel only your own projects.");
            return "redirect:/viewMyProjects";
        }

        if (!canCancelProject(project)) {
            redirectAttributes.addFlashAttribute("warning", "This project cannot be cancelled now. Running, submitted, revision, completed, or funded projects are protected.");
            return "redirect:/viewMyProjects";
        }

        String cleanReason = cleanText(cancellationReason, 1000);
        if (cleanReason.length() == 0) {
            cleanReason = "Cancelled by client";
        }

        project.setStatus("Cancelled");
        project.setCancellationReason(cleanReason);
        project.setCancelledAt(LocalDateTime.now().toString());
        project.setUpdatedAt(LocalDateTime.now().toString());

        PaymentModel payment = paymentService.getPaymentByProjectId(projectId);
        if (payment != null && "Unpaid".equalsIgnoreCase(payment.getPaymentStatus())) {
            payment.setPaymentStatus("Cancelled");
            payment.setUpdatedAt(LocalDateTime.now().toString());
            paymentService.updatePayment(payment);
        }

        projectService.updateProject(project);

        if (project.getAssignedFreelancer() != null) {
            notifyUser(project.getAssignedFreelancer().getId(), "FREELANCER", "Client cancelled project: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Project cancelled successfully.");
        return "redirect:/viewMyProjects";
    }

    @GetMapping("/cancelProject")
    public String blockCancelProjectGet(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("warning", "Please use the Cancel Project button from My Projects.");
        return "redirect:/viewMyProjects";
    }

@GetMapping("/viewMyProjects")
    public String viewMyProjects(HttpSession session,
                                 Model model,
                                 @RequestParam(value = "q", required = false) String q,
                                 @RequestParam(value = "status", required = false, defaultValue = "all") String status,
                                 @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
                                 @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        String search = q == null ? "" : q.trim();
        String statusFilter = status == null ? "all" : status.trim();
        String sortOption = sort == null ? "latest" : sort.trim();

        if (statusFilter.length() == 0) {
            statusFilter = "all";
        }

        int pageSize = 6;

        if (page < 1) {
            page = 1;
        }

        long totalFilteredProjects = projectService.countClientProjectsForWorkspace(client.getId(), search, statusFilter);
        int totalPages = (int) Math.ceil(totalFilteredProjects / (double) pageSize);

        if (totalPages < 1) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * pageSize;

        List<ProjectModel> projects = projectService.getClientProjectsForWorkspace(client.getId(), search, statusFilter, sortOption, offset, pageSize);

        long totalAllProjects = projectService.countProjectsByClient(client.getId());
        long openCount = projectService.countProjectsByClientAndStatus(client.getId(), "Open");
        long activeCount = projectService.countProjectsByClientAndStatus(client.getId(), "In Progress")
                + projectService.countProjectsByClientAndStatus(client.getId(), "Payment Pending");
        long submittedCount = projectService.countProjectsByClientAndStatus(client.getId(), "Submitted");
        long revisionCount = projectService.countProjectsByClientAndStatus(client.getId(), "Revision Requested");
        long completedCount = projectService.countProjectsByClientAndStatus(client.getId(), "Completed");

        model.addAttribute("projects", projects);
        model.addAttribute("paymentMap", buildPaymentMap(projects));
        model.addAttribute("searchQuery", search);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("sortOption", sortOption);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalFilteredProjects", totalFilteredProjects);

        model.addAttribute("totalAllProjects", totalAllProjects);
        model.addAttribute("openCount", openCount);
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("submittedCount", submittedCount);
        model.addAttribute("revisionCount", revisionCount);
        model.addAttribute("completedCount", completedCount);

        return "viewMyProjects";
    }

    @GetMapping("/viewAllProjects")
    public String viewAllProjects(HttpSession session,
                                  Model model,
                                  @RequestParam(value = "q", required = false) String q,
                                  @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
                                  @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        String search = q == null ? "" : q.trim();
        String sortOption = sort == null ? "latest" : sort.trim();

        int pageSize = 8;

        if (page < 1) {
            page = 1;
        }

        long totalOpenProjects = projectService.countOpenProjectsForMarketplace(search);
        int totalPages = (int) Math.ceil(totalOpenProjects / (double) pageSize);

        if (totalPages < 1) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * pageSize;

        List<ProjectModel> projects = projectService.getOpenProjectsForMarketplace(search, sortOption, offset, pageSize);
        Set<Integer> savedProjectIds = new HashSet<Integer>(savedProjectService.getSavedProjectIdsByFreelancer(freelancer.getId()));
        long savedCount = savedProjectService.countSavedProjectsByFreelancer(freelancer.getId());

        model.addAttribute("projects", projects);
        model.addAttribute("savedProjectIds", savedProjectIds);
        model.addAttribute("savedCount", savedCount);
        model.addAttribute("searchQuery", search);
        model.addAttribute("sortOption", sortOption);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalOpenProjects", totalOpenProjects);

        return "viewAllProjects";
    }

    @GetMapping("/freelancerAssignedProjects")
    public String freelancerAssignedProjects(HttpSession session, Model model) {
        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        List<ProjectModel> projects = projectService.getProjectsByAssignedFreelancerId(freelancer.getId());
        model.addAttribute("projects", projects);
        model.addAttribute("paymentMap", buildPaymentMap(projects));

        return "freelancerAssignedProjects";
    }

    @GetMapping("/submitWorkPage")
    public String submitWorkPage(@RequestParam("projectId") int projectId,
                                 HttpSession session,
                                 Model model) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isAssignedFreelancer(project, freelancer)) {
            return "redirect:/freelancerAssignedProjects";
        }

        if (!canSubmitWork(project)) {
            return "redirect:/freelancerAssignedProjects";
        }

        model.addAttribute("project", project);
        return "submitWork";
    }

    @PostMapping("/submitWork")
    public String submitWork(@RequestParam("projectId") int projectId,
                             @RequestParam("submissionMessage") String submissionMessage,
                             @RequestParam("submissionFile") MultipartFile submissionFile,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isAssignedFreelancer(project, freelancer)) {
            return "redirect:/freelancerAssignedProjects";
        }

        if (!canSubmitWork(project)) {
            return "redirect:/freelancerAssignedProjects";
        }

        String cleanSubmissionMessage = cleanText(submissionMessage, 3000);

        if (cleanSubmissionMessage.length() == 0) {
            model.addAttribute("project", project);
            model.addAttribute("error", "Please write a short delivery message before submitting.");
            return "submitWork";
        }

        if (submissionFile == null || submissionFile.isEmpty()) {
            model.addAttribute("project", project);
            model.addAttribute("error", "Please upload your final work file before submitting.");
            return "submitWork";
        }

        if (submissionFile.getSize() > MAX_SUBMISSION_FILE_SIZE) {
            model.addAttribute("project", project);
            model.addAttribute("error", "File is too large. Upload a file smaller than 50 MB.");
            return "submitWork";
        }

        if (!isAllowedFile(submissionFile.getOriginalFilename())) {
            model.addAttribute("project", project);
            model.addAttribute("error", "Invalid file type. Upload zip, rar, pdf, doc, image, txt, ppt, or excel files only.");
            return "submitWork";
        }

        try {
            String originalName = cleanFileName(submissionFile.getOriginalFilename());
            String extension = "";

            int dot = originalName.lastIndexOf(".");
            if (dot != -1) {
                extension = originalName.substring(dot);
            }

            String storedName = "project_" + project.getId() +
                    "_freelancer_" + freelancer.getId() +
                    "_" + UUID.randomUUID().toString() + extension;

            Path uploadRoot = getUploadRoot();
            Path targetPath = uploadRoot.resolve(storedName).normalize();

            if (!targetPath.startsWith(uploadRoot.normalize())) {
                model.addAttribute("project", project);
                model.addAttribute("error", "Invalid file path.");
                return "submitWork";
            }

            Files.copy(submissionFile.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);

            project.setSubmissionMessage(cleanSubmissionMessage);
            project.setSubmissionDate(LocalDate.now().toString());
            project.setSubmissionOriginalFileName(originalName);
            project.setSubmissionStoredFileName(storedName);
            project.setSubmissionFileType(submissionFile.getContentType());
            project.setSubmissionFileSize(submissionFile.getSize());
            project.setStatus("Submitted");

            projectService.updateProject(project);

            if (project.getClient() != null) {
                if (project.getRevisionCount() > 0) {
                    notifyUser(project.getClient().getId(), "CLIENT", "Revised work submitted by " + freelancer.getName() + " for project: " + project.getTitle());
                } else {
                    notifyUser(project.getClient().getId(), "CLIENT", "Work submitted by " + freelancer.getName() + " for project: " + project.getTitle());
                }
            }

            redirectAttributes.addFlashAttribute("success", project.getRevisionCount() > 0 ? "Revised work submitted successfully. The client has been notified." : "Work submitted successfully. The client has been notified.");
            return "redirect:/freelancerAssignedProjects";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("project", project);
            model.addAttribute("error", "File upload failed. Please try again.");
            return "submitWork";
        }
    }

    @GetMapping("/downloadSubmittedFile")
    public ResponseEntity<Resource> downloadSubmittedFile(@RequestParam("projectId") int projectId,
                                                          HttpSession session) {

        try {
            ProjectModel project = projectService.getProjectById(projectId);

            if (project == null ||
                project.getSubmissionStoredFileName() == null ||
                project.getSubmissionStoredFileName().trim().isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            ClientModel client = (ClientModel) session.getAttribute("clientSession");
            FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

            boolean allowed = isClientOwner(project, client) || isAssignedFreelancer(project, freelancer);

            if (!allowed) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }

            Path uploadRoot = getUploadRoot();
            Path filePath = uploadRoot.resolve(project.getSubmissionStoredFileName()).normalize();

            if (!filePath.startsWith(uploadRoot.normalize())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }

            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            String downloadName = project.getSubmissionOriginalFileName();

            if (downloadName == null || downloadName.trim().isEmpty()) {
                downloadName = project.getSubmissionStoredFileName();
            }

            downloadName = downloadName.replaceAll("[\\r\\n\"]", "_");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + downloadName + "\"")
                    .body(resource);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/requestRevisionPage")
    public String requestRevisionPage(@RequestParam("projectId") int projectId,
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

        if (!"Submitted".equalsIgnoreCase(project.getStatus())) {
            return "redirect:/viewMyProjects";
        }

        model.addAttribute("project", project);
        return "requestRevision";
    }

    @PostMapping("/requestRevision")
    public String requestRevision(@RequestParam("projectId") int projectId,
                                  @RequestParam("revisionMessage") String revisionMessage,
                                  HttpSession session) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            return "redirect:/viewMyProjects";
        }

        if (!"Submitted".equalsIgnoreCase(project.getStatus())) {
            return "redirect:/viewMyProjects";
        }

        String cleanRevisionMessage = cleanText(revisionMessage, 3000);

        if (cleanRevisionMessage.length() == 0) {
            return "redirect:/requestRevisionPage?projectId=" + projectId;
        }

        project.setRevisionMessage(cleanRevisionMessage);
        project.setRevisionRequestedDate(LocalDate.now().toString());
        project.setRevisionCount(project.getRevisionCount() + 1);
        project.setStatus("Revision Requested");

        projectService.updateProject(project);

        if (project.getAssignedFreelancer() != null) {
            notifyUser(project.getAssignedFreelancer().getId(), "FREELANCER", "Revision requested for project: " + project.getTitle());
        }

        return "redirect:/viewMyProjects";
    }

    @GetMapping("/markProjectCompleted")
    public String markProjectCompletedGet() {
        return "redirect:/viewMyProjects";
    }

    @PostMapping("/markProjectCompleted")
    public String markProjectCompleted(@RequestParam("projectId") int projectId,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isClientOwner(project, client)) {
            return "redirect:/viewMyProjects";
        }

        if (!"Submitted".equalsIgnoreCase(project.getStatus())) {
            return "redirect:/viewMyProjects";
        }

        if (project.getSubmissionStoredFileName() == null || project.getSubmissionStoredFileName().trim().isEmpty()) {
            return "redirect:/viewMyProjects";
        }

        PaymentModel payment = paymentService.getPaymentByProjectId(projectId);
        if (payment != null) {
            if (!"Escrow Funded".equalsIgnoreCase(payment.getPaymentStatus())) {
                redirectAttributes.addFlashAttribute("warning", "This project cannot be completed until escrow is funded.");
                return "redirect:/viewMyProjects";
            }

            payment.setPaymentStatus("Released");
            payment.setReleasedAt(LocalDateTime.now().toString());
            payment.setUpdatedAt(LocalDateTime.now().toString());
            paymentService.updatePayment(payment);
        }

        project.setStatus("Completed");
        projectService.updateProject(project);

        if (project.getAssignedFreelancer() != null) {
            notifyUser(project.getAssignedFreelancer().getId(), "FREELANCER", "Client marked project as completed: " + project.getTitle());
        }

        redirectAttributes.addFlashAttribute("success", "Project completed successfully. Escrow payment has been released to the freelancer.");
        return "redirect:/viewMyProjects";
    }
}
