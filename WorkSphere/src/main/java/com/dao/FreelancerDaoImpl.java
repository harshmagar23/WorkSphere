package com.dao;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.stereotype.Repository;

import com.model.FreelancerModel;

@Repository
public class FreelancerDaoImpl implements FreelancerDao {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void saveFreelancer(FreelancerModel freelance) {
        entityManager.persist(freelance);
    }

    @Override
    public FreelancerModel loginFreelancer(String email, String password) {
        try {
            String hql = "from FreelancerModel where lower(email)=:email and password=:password";
            TypedQuery<FreelancerModel> query = entityManager.createQuery(hql, FreelancerModel.class);
            query.setParameter("email", email == null ? "" : email.trim().toLowerCase());
            query.setParameter("password", password);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public FreelancerModel getByEmail(String email) {
        try {
            String hql = "from FreelancerModel where lower(email)=:email";
            TypedQuery<FreelancerModel> query = entityManager.createQuery(hql, FreelancerModel.class);
            query.setParameter("email", email == null ? "" : email.trim().toLowerCase());
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void updatePassword(String email, String password) {
        entityManager.createQuery("update FreelancerModel set password=:password where lower(email)=:email")
                .setParameter("password", password)
                .setParameter("email", email == null ? "" : email.trim().toLowerCase())
                .executeUpdate();
    }
}
