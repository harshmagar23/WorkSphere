package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.FreelancerProfileDao;
import com.model.FreelancerProfileModel;

@Service
@Transactional
public class FreelancerProfileServiceImpl implements FreelancerProfileService {

    @Autowired
    private FreelancerProfileDao freelancerProfileDao;

    @Override
    public void saveOrUpdateProfile(FreelancerProfileModel profile) {
        freelancerProfileDao.saveOrUpdateProfile(profile);
    }

    @Override
    public FreelancerProfileModel getProfileByFreelancerId(int freelancerId) {
        return freelancerProfileDao.getProfileByFreelancerId(freelancerId);
    }
}