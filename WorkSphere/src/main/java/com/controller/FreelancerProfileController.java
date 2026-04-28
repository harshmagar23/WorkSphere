package com.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.model.FreelancerModel;
import com.model.FreelancerProfileModel;
import com.service.FreelancerProfileService;
import com.service.ReviewService;

@Controller
public class FreelancerProfileController {

    @Autowired
    private FreelancerProfileService freelancerProfileService;

    @Autowired
    private ReviewService reviewService;

    @GetMapping("/editFreelancerProfile")
    public String editFreelancerProfilePage(HttpSession session, Model model) {
        FreelancerModel freelancerSession = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancerSession == null) {
            return "redirect:/freelancerLogin";
        }

        FreelancerProfileModel profile = freelancerProfileService.getProfileByFreelancerId(freelancerSession.getId());

        if (profile == null) {
            profile = new FreelancerProfileModel();
            profile.setFreelancerId(freelancerSession.getId());
        }

        model.addAttribute("profile", profile);
        return "editFreelancerProfile";
    }

    @PostMapping("/saveFreelancerProfile")
    public String saveFreelancerProfile(FreelancerProfileModel profile, HttpSession session) {
        FreelancerModel freelancerSession = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancerSession == null) {
            return "redirect:/freelancerLogin";
        }

        profile.setFreelancerId(freelancerSession.getId());
        freelancerProfileService.saveOrUpdateProfile(profile);

        return "redirect:/viewFreelancerProfile";
    }

    @GetMapping("/viewFreelancerProfile")
    public String viewFreelancerProfile(HttpSession session, Model model) {
        FreelancerModel freelancerSession = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancerSession == null) {
            return "redirect:/freelancerLogin";
        }

        FreelancerProfileModel profile = freelancerProfileService.getProfileByFreelancerId(freelancerSession.getId());
        Double avgRating = reviewService.getAverageRatingByFreelancerId(freelancerSession.getId());
        Long totalReviews = reviewService.getTotalReviewsByFreelancerId(freelancerSession.getId());

        model.addAttribute("profile", profile);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("totalReviews", totalReviews);
        model.addAttribute("freelancer", freelancerSession);

        return "freelancerProfile";
    }

    @GetMapping("/publicFreelancerProfile")
    public String publicFreelancerProfile(int freelancerId, Model model) {
        FreelancerProfileModel profile = freelancerProfileService.getProfileByFreelancerId(freelancerId);
        Double avgRating = reviewService.getAverageRatingByFreelancerId(freelancerId);
        Long totalReviews = reviewService.getTotalReviewsByFreelancerId(freelancerId);

        model.addAttribute("profile", profile);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("totalReviews", totalReviews);

        return "freelancerProfile";
    }
}