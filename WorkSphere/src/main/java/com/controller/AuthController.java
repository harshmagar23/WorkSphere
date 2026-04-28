package com.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.service.ClientService;
import com.service.FreelancerService;

@Controller
public class AuthController {

    @Autowired
    private ClientService clientService;

    @Autowired
    private FreelancerService freelancerService;

    // ================= CLIENT =================

    @GetMapping("/clientForgotPassword")
    public String clientForgotPage() {
        return "clientForgotPassword";
    }

    @PostMapping("/clientCheckEmail")
    public String clientCheckEmail(@RequestParam("email") String email,
                                   HttpSession session,
                                   Model model) {

        if (clientService.checkEmailExists(email)) {
            session.setAttribute("clientResetEmail", email);
            return "clientResetPassword";
        }

        model.addAttribute("error", "Email not found. Please enter your registered client email.");
        return "clientForgotPassword";
    }

    @PostMapping("/clientResetPassword")
    public String clientResetPassword(@RequestParam("password") String password,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {

        String email = (String) session.getAttribute("clientResetEmail");

        if (email == null || email.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Password reset session expired. Please try again.");
            return "redirect:/clientForgotPassword";
        }

        clientService.updatePassword(email, password);
        session.removeAttribute("clientResetEmail");

        redirectAttributes.addFlashAttribute("msg", "Password updated successfully. Please login.");
        return "redirect:/clientLogin";
    }

    // ================= FREELANCER =================

    @GetMapping("/freelancerForgotPassword")
    public String freelancerForgotPage() {
        return "freelancerForgotPassword";
    }

    @PostMapping("/freelancerCheckEmail")
    public String freelancerCheckEmail(@RequestParam("email") String email,
                                       HttpSession session,
                                       Model model) {

        if (freelancerService.checkEmailExists(email)) {
            session.setAttribute("freelancerResetEmail", email);
            return "freelancerResetPassword";
        }

        model.addAttribute("error", "Email not found. Please enter your registered freelancer email.");
        return "freelancerForgotPassword";
    }

    @PostMapping("/freelancerResetPassword")
    public String freelancerResetPassword(@RequestParam("password") String password,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {

        String email = (String) session.getAttribute("freelancerResetEmail");

        if (email == null || email.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Password reset session expired. Please try again.");
            return "redirect:/freelancerForgotPassword";
        }

        freelancerService.updatePassword(email, password);
        session.removeAttribute("freelancerResetEmail");

        redirectAttributes.addFlashAttribute("msg", "Password updated successfully. Please login.");
        return "redirect:/freelancerLogin";
    }
}