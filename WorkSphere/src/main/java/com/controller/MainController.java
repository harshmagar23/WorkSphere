package com.controller;

import java.util.List;
import java.util.regex.Pattern;

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
import com.service.BidService;
import com.service.ClientService;
import com.service.EmailService;
import com.service.FreelancerService;
import com.service.NotificationService;
import com.service.ProjectService;

@Controller
public class MainController {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Autowired
    private ClientService clientService;

    @Autowired
    private FreelancerService freelancerService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private BidService bidService;

    @Autowired(required = false)
    private EmailService emailService;

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeEmail(String email) {
        return trim(email).toLowerCase();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    private boolean isValidPassword(String password) {
        return password != null && password.trim().length() >= 6;
    }

    @GetMapping({"/", "/index", "/home"})
    public String indexPage() {
        return "redirect:/index.jsp";
    }

    @GetMapping({
            "/clientRegister",
            "/clientRegistration",
            "/registerClient",
            "/client/register"
    })
    public String clientRegisterPage() {
        return "clientRegister";
    }

    @PostMapping({
            "/saveClient",
            "/clientRegister",
            "/clientRegistration",
            "/client/register"
    })
    public String saveClient(ClientModel model, RedirectAttributes redirectAttributes) {

        String name = trim(model.getName());
        String email = normalizeEmail(model.getEmail());
        String password = model.getPassword();

        if (isBlank(name)) {
            redirectAttributes.addFlashAttribute("msg", "Please enter your full name.");
            return "redirect:/clientRegister";
        }

        if (!isValidEmail(email)) {
            redirectAttributes.addFlashAttribute("msg", "Please enter a valid email address.");
            return "redirect:/clientRegister";
        }

        if (!isValidPassword(password)) {
            redirectAttributes.addFlashAttribute("msg", "Password must be at least 6 characters long.");
            return "redirect:/clientRegister";
        }

        if (clientService.checkEmailExists(email)) {
            redirectAttributes.addFlashAttribute("msg",
                    "This email is already registered as a client. Please login or use another email.");
            return "redirect:/clientRegister";
        }

        model.setName(name);
        model.setEmail(email);

        clientService.saveUser(model);

        boolean emailSent = false;

        if (emailService != null) {
            emailSent = emailService.sendClientRegistrationSuccessEmail(email, name);
        }

        if (emailSent) {
            redirectAttributes.addFlashAttribute("msg",
                    "Registration successful. Confirmation email sent. Please login.");
        } else {
            redirectAttributes.addFlashAttribute("msg",
                    "Registration successful. Please login. Email notification is not configured or could not be sent.");
        }

        return "redirect:/clientLogin";
    }

    @GetMapping({
            "/freelancerRegister",
            "/freelancerRegistration",
            "/registerFreelancer",
            "/freelancer/register"
    })
    public String freelancerRegisterPage() {
        return "freelancerRegister";
    }

    @PostMapping({
            "/saveFreelancer",
            "/freelancerRegister",
            "/freelancerRegistration",
            "/freelancer/register"
    })
    public String saveFreelancer(FreelancerModel model, RedirectAttributes redirectAttributes) {

        String name = trim(model.getName());
        String email = normalizeEmail(model.getEmail());
        String password = model.getPassword();

        if (isBlank(name)) {
            redirectAttributes.addFlashAttribute("msg", "Please enter your full name.");
            return "redirect:/freelancerRegister";
        }

        if (!isValidEmail(email)) {
            redirectAttributes.addFlashAttribute("msg", "Please enter a valid email address.");
            return "redirect:/freelancerRegister";
        }

        if (!isValidPassword(password)) {
            redirectAttributes.addFlashAttribute("msg", "Password must be at least 6 characters long.");
            return "redirect:/freelancerRegister";
        }

        if (freelancerService.checkEmailExists(email)) {
            redirectAttributes.addFlashAttribute("msg",
                    "This email is already registered as a freelancer. Please login or use another email.");
            return "redirect:/freelancerRegister";
        }

        model.setName(name);
        model.setEmail(email);

        freelancerService.saveFreelancer(model);

        boolean emailSent = false;

        if (emailService != null) {
            emailSent = emailService.sendFreelancerRegistrationSuccessEmail(email, name);
        }

        if (emailSent) {
            redirectAttributes.addFlashAttribute("msg",
                    "Registration successful. Confirmation email sent. Please login.");
        } else {
            redirectAttributes.addFlashAttribute("msg",
                    "Registration successful. Please login. Email notification is not configured or could not be sent.");
        }

        return "redirect:/freelancerLogin";
    }

    @GetMapping({
            "/clientLogin",
            "/loginClient",
            "/client/login"
    })
    public String clientLoginPage() {
        return "clientLogin";
    }

    @PostMapping({
            "/clientLogin",
            "/loginClient",
            "/client/login"
    })
    public String clientLogin(@RequestParam("email") String email,
                              @RequestParam("password") String password,
                              HttpSession session,
                              Model model) {

        ClientModel client = clientService.loginClient(normalizeEmail(email), password);

        if (client != null) {
            session.setAttribute("clientSession", client);
            return "redirect:/clientDashboard";
        }

        model.addAttribute("msg", "Invalid Email or Password");
        return "clientLogin";
    }

    @GetMapping({
            "/freelancerLogin",
            "/loginFreelancer",
            "/freelancer/login"
    })
    public String freelancerLoginPage() {
        return "freelancerLogin";
    }

    @PostMapping({
            "/freelancerLogin",
            "/loginFreelancer",
            "/freelancer/login"
    })
    public String freelancerLogin(@RequestParam("email") String email,
                                  @RequestParam("password") String password,
                                  HttpSession session,
                                  Model model) {

        FreelancerModel freelancer =
                freelancerService.loginFreelancer(normalizeEmail(email), password);

        if (freelancer != null) {
            session.setAttribute("freelancerSession", freelancer);
            return "redirect:/freelancerDashboard";
        }

        model.addAttribute("msg", "Invalid Email or Password");
        return "freelancerLogin";
    }

    @GetMapping({
            "/clientDashboard",
            "/client/dashboard"
    })
    public String clientDashboard(HttpSession session, Model model) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        long totalProjects = projectService.countProjectsByClient(client.getId());
        long openProjects = projectService.countProjectsByClientAndStatus(client.getId(), "Open");
        long inProgressProjects = projectService.countProjectsByClientAndStatus(client.getId(), "In Progress");
        long completedProjects = projectService.countProjectsByClientAndStatus(client.getId(), "Completed");
        long totalBids = bidService.countBidsByClientProjects(client.getId());
        long unreadCount = notificationService.getUnreadCount(client.getId(), "CLIENT");

        model.addAttribute("totalProjects", totalProjects);
        model.addAttribute("openProjects", openProjects);
        model.addAttribute("inProgressProjects", inProgressProjects);
        model.addAttribute("completedProjects", completedProjects);
        model.addAttribute("totalBids", totalBids);
        model.addAttribute("unreadNotificationCount", unreadCount);

        return "clientDashboard";
    }

    @GetMapping({
            "/freelancerDashboard",
            "/freelancer/dashboard"
    })
    public String freelancerDashboard(HttpSession session, Model model) {

        FreelancerModel freelancer =
                (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        long totalBids = bidService.countBidsByFreelancer(freelancer.getId());
        long acceptedBids = bidService.countAcceptedBidsByFreelancer(freelancer.getId());
        long assignedProjects = projectService.countProjectsByFreelancer(freelancer.getId());
        long completedProjects = projectService.countCompletedProjectsByFreelancer(freelancer.getId());
        long unreadCount = notificationService.getUnreadCount(freelancer.getId(), "FREELANCER");

        model.addAttribute("totalBids", totalBids);
        model.addAttribute("acceptedBids", acceptedBids);
        model.addAttribute("assignedProjects", assignedProjects);
        model.addAttribute("completedProjects", completedProjects);
        model.addAttribute("unreadNotificationCount", unreadCount);

        return "freelancerDashboard";
    }

    @GetMapping({
            "/logout",
            "/clientLogout",
            "/client/logout"
    })
    public String clientLogout(HttpSession session) {
        session.removeAttribute("clientSession");
        return "redirect:/clientLogin";
    }

    @GetMapping({
            "/freelancerLogout",
            "/freelancer/logout"
    })
    public String freelancerLogout(HttpSession session) {
        session.removeAttribute("freelancerSession");
        return "redirect:/freelancerLogin";
    }

    @GetMapping({
            "/clientNotifications",
            "/client/notifications"
    })
    public String clientNotifications(HttpSession session, Model model) {

        ClientModel client = (ClientModel) session.getAttribute("clientSession");

        if (client == null) {
            return "redirect:/clientLogin";
        }

        notificationService.markAllAsRead(client.getId(), "CLIENT");

        List<NotificationModel> notifications =
                notificationService.getNotificationsByUser(client.getId(), "CLIENT");

        model.addAttribute("notifications", notifications);

        return "clientNotifications";
    }

    @GetMapping({
            "/freelancerNotifications",
            "/freelancer/notifications"
    })
    public String freelancerNotifications(HttpSession session, Model model) {

        FreelancerModel freelancer =
                (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancer == null) {
            return "redirect:/freelancerLogin";
        }

        notificationService.markAllAsRead(freelancer.getId(), "FREELANCER");

        List<NotificationModel> notifications =
                notificationService.getNotificationsByUser(freelancer.getId(), "FREELANCER");

        model.addAttribute("notifications", notifications);

        return "freelancerNotifications";
    }
}