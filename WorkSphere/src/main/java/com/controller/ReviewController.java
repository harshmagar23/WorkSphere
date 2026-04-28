package com.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.model.ClientModel;
import com.model.FreelancerModel;
import com.model.ReviewModel;
import com.service.ReviewService;

@Controller
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @GetMapping("/giveReview")
    public String giveReviewPage(int projectId, int freelancerId, HttpSession session, Model model) {
        ClientModel clientSession = (ClientModel) session.getAttribute("clientSession");

        if (clientSession == null) {
            return "redirect:/clientLogin";
        }

        boolean alreadyReviewed = reviewService.hasClientAlreadyReviewedProject(
                projectId,
                clientSession.getId(),
                freelancerId
        );

        if (alreadyReviewed) {
            return "redirect:/clientDashboard";
        }

        model.addAttribute("projectId", projectId);
        model.addAttribute("freelancerId", freelancerId);

        return "clientGiveReview";
    }

    @PostMapping("/saveReview")
    public String saveReview(ReviewModel review, HttpSession session) {
        ClientModel clientSession = (ClientModel) session.getAttribute("clientSession");

        if (clientSession == null) {
            return "redirect:/clientLogin";
        }

        boolean alreadyReviewed = reviewService.hasClientAlreadyReviewedProject(
                review.getProjectId(),
                clientSession.getId(),
                review.getFreelancerId()
        );

        if (!alreadyReviewed) {
            review.setClientId(clientSession.getId());
            reviewService.saveReview(review);
        }

        return "redirect:/clientDashboard";
    }

    @GetMapping("/freelancerReviews")
    public String freelancerReviews(HttpSession session, Model model) {
        FreelancerModel freelancerSession = (FreelancerModel) session.getAttribute("freelancerSession");

        if (freelancerSession == null) {
            return "redirect:/freelancerLogin";
        }

        List<ReviewModel> reviewList = reviewService.getReviewsByFreelancerId(freelancerSession.getId());
        Double avgRating = reviewService.getAverageRatingByFreelancerId(freelancerSession.getId());
        Long totalReviews = reviewService.getTotalReviewsByFreelancerId(freelancerSession.getId());

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("totalReviews", totalReviews);

        return "freelancerReviews";
    }
}