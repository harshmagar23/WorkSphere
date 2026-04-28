package com.service;

import java.util.List;
import com.model.ReviewModel;

public interface ReviewService {
    void saveReview(ReviewModel review);
    List<ReviewModel> getReviewsByFreelancerId(int freelancerId);
    Double getAverageRatingByFreelancerId(int freelancerId);
    Long getTotalReviewsByFreelancerId(int freelancerId);
    boolean hasClientAlreadyReviewedProject(int projectId, int clientId, int freelancerId);
}