package com.dao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.model.FreelancerProfileModel;

@Repository
public class FreelancerProfileDaoImpl implements FreelancerProfileDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveOrUpdateProfile(FreelancerProfileModel profile) {
        Session session = sessionFactory.getCurrentSession();

        String hql = "from FreelancerProfileModel where freelancerId = :freelancerId";
        Query<FreelancerProfileModel> query = session.createQuery(hql, FreelancerProfileModel.class);
        query.setParameter("freelancerId", profile.getFreelancerId());

        FreelancerProfileModel existingProfile = query.uniqueResult();

        if (existingProfile != null) {
            existingProfile.setProfessionalTitle(profile.getProfessionalTitle());
            existingProfile.setBio(profile.getBio());
            existingProfile.setSkills(profile.getSkills());
            existingProfile.setExperienceYears(profile.getExperienceYears());
            existingProfile.setHourlyRate(profile.getHourlyRate());
            existingProfile.setProfileImage(profile.getProfileImage());

            session.update(existingProfile);
        } else {
            session.save(profile);
        }
    }

    @Override
    public FreelancerProfileModel getProfileByFreelancerId(int freelancerId) {
        Session session = sessionFactory.getCurrentSession();

        String hql = "from FreelancerProfileModel where freelancerId = :freelancerId";
        Query<FreelancerProfileModel> query = session.createQuery(hql, FreelancerProfileModel.class);
        query.setParameter("freelancerId", freelancerId);

        return query.uniqueResult();
    }
}