package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.ReviewDao;
import com.model.ReviewModel;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewDao reviewDao;

    @Override
    public void saveReview(ReviewModel review) {
        reviewDao.saveReview(review);
    }

    @Override
    public List<ReviewModel> getReviewsByFreelancerId(int freelancerId) {
        return reviewDao.getReviewsByFreelancerId(freelancerId);
    }

    @Override
    public Double getAverageRatingByFreelancerId(int freelancerId) {
        return reviewDao.getAverageRatingByFreelancerId(freelancerId);
    }

    @Override
    public Long getTotalReviewsByFreelancerId(int freelancerId) {
        return reviewDao.getTotalReviewsByFreelancerId(freelancerId);
    }

    @Override
    public boolean hasClientAlreadyReviewedProject(int projectId, int clientId, int freelancerId) {
        return reviewDao.hasClientAlreadyReviewedProject(projectId, clientId, freelancerId);
    }
}