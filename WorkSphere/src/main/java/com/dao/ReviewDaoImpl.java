package com.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.model.ReviewModel;

@Repository
public class ReviewDaoImpl implements ReviewDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveReview(ReviewModel review) {
        Session session = sessionFactory.getCurrentSession();
        session.save(review);
    }

    @Override
    public List<ReviewModel> getReviewsByFreelancerId(int freelancerId) {
        Session session = sessionFactory.getCurrentSession();

        String hql = "from ReviewModel where freelancerId = :freelancerId order by reviewId desc";
        Query<ReviewModel> query = session.createQuery(hql, ReviewModel.class);
        query.setParameter("freelancerId", freelancerId);

        return query.list();
    }

    @Override
    public Double getAverageRatingByFreelancerId(int freelancerId) {
        Session session = sessionFactory.getCurrentSession();

        String hql = "select avg(rating) from ReviewModel where freelancerId = :freelancerId";
        Query<Double> query = session.createQuery(hql, Double.class);
        query.setParameter("freelancerId", freelancerId);

        Double avgRating = query.uniqueResult();
        return avgRating != null ? avgRating : 0.0;
    }

    @Override
    public Long getTotalReviewsByFreelancerId(int freelancerId) {
        Session session = sessionFactory.getCurrentSession();

        String hql = "select count(*) from ReviewModel where freelancerId = :freelancerId";
        Query<Long> query = session.createQuery(hql, Long.class);
        query.setParameter("freelancerId", freelancerId);

        Long total = query.uniqueResult();
        return total != null ? total : 0L;
    }

    @Override
    public boolean hasClientAlreadyReviewedProject(int projectId, int clientId, int freelancerId) {
        Session session = sessionFactory.getCurrentSession();

        String hql = "select count(*) from ReviewModel where projectId = :projectId and clientId = :clientId and freelancerId = :freelancerId";
        Query<Long> query = session.createQuery(hql, Long.class);
        query.setParameter("projectId", projectId);
        query.setParameter("clientId", clientId);
        query.setParameter("freelancerId", freelancerId);

        Long count = query.uniqueResult();
        return count != null && count > 0;
    }
}