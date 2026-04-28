package com.controller;

import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.model.FreelancerModel;
import com.model.ProjectModel;
import com.model.SavedProjectModel;
import com.service.ProjectService;
import com.service.SavedProjectService;

@Controller
public class SavedProjectController {

    @Autowired
    private SavedProjectService savedProjectService;

    @Autowired
    private ProjectService projectService;

    private boolean isOpen(ProjectModel project) {
        return project != null && "Open".equalsIgnoreCase(project.getStatus());
    }

    private boolean isSafeReturnUrl(String returnUrl) {
        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            return false;
        }

        String r = returnUrl.trim();

        return r.startsWith("viewAllProjects")
                || r.startsWith("savedProjects")
                || r.startsWith("freelancerDashboard");
    }

    private String redirectBack(String returnUrl) {
        if (isSafeReturnUrl(returnUrl)) {
            return "redirect:/" + returnUrl.trim();
        }

        return "redirect:/viewAllProjects";
    }

    @GetMapping("/savedProjects")
    public String savedProjects(HttpSession session,
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

        long totalSavedProjects = savedProjectService.countSavedProjectsByFreelancer(freelancer.getId(), search);
        long allSavedProjects = savedProjectService.countSavedProjectsByFreelancer(freelancer.getId());
        int totalPages = (int) Math.ceil(totalSavedProjects / (double) pageSize);

        if (totalPages < 1) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * pageSize;

        List<SavedProjectModel> savedProjects = savedProjectService.getSavedProjectsByFreelancer(
                freelancer.getId(), search, sortOption, offset, pageSize
        );

        model.addAttribute("savedProjects", savedProjects);
        model.addAttribute("searchQuery", search);
        model.addAttribute("sortOption", sortOption);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalSavedProjects", totalSavedProjects);
        model.addAttribute("allSavedProjects", allSavedProjects);

        return "savedProjects";
    }

    @PostMapping("/saveProjectBookmark")
    public String saveProjectBookmark(@RequestParam("projectId") int projectId,
                                      @RequestParam(value = "returnUrl", required = false) String returnUrl,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes,
                                      HttpServletRequest request) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        ProjectModel project = projectService.getProjectById(projectId);

        if (!isOpen(project)) {
            redirectAttributes.addFlashAttribute("warning", "Only open projects can be saved.");
            return redirectBack(returnUrl);
        }

        SavedProjectModel existing = savedProjectService.getSavedProjectByFreelancerAndProject(freelancer.getId(), projectId);

        if (existing != null) {
            redirectAttributes.addFlashAttribute("info", "This project is already in your saved list.");
            return redirectBack(returnUrl);
        }

        SavedProjectModel savedProject = new SavedProjectModel();
        savedProject.setFreelancer(freelancer);
        savedProject.setProject(project);
        savedProject.setSavedAt(LocalDateTime.now().toString());

        savedProjectService.saveSavedProject(savedProject);

        redirectAttributes.addFlashAttribute("success", "Project saved successfully. You can apply later from Saved Projects.");
        return redirectBack(returnUrl);
    }

    @PostMapping("/removeSavedProject")
    public String removeSavedProject(@RequestParam("projectId") int projectId,
                                     @RequestParam(value = "returnUrl", required = false) String returnUrl,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {

        FreelancerModel freelancer = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        SavedProjectModel savedProject = savedProjectService.getSavedProjectByFreelancerAndProject(freelancer.getId(), projectId);

        if (savedProject == null) {
            redirectAttributes.addFlashAttribute("warning", "This project is not in your saved list.");
            return redirectBack(returnUrl);
        }

        savedProjectService.deleteSavedProject(savedProject);

        redirectAttributes.addFlashAttribute("success", "Project removed from your saved list.");
        return redirectBack(returnUrl);
    }

    @GetMapping("/saveProjectBookmark")
    public String saveProjectBookmarkGet() {
        return "redirect:/viewAllProjects";
    }

    @GetMapping("/removeSavedProject")
    public String removeSavedProjectGet() {
        return "redirect:/savedProjects";
    }
}
