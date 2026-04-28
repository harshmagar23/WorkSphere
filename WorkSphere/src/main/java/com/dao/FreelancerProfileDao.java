package com.dao;

import com.model.FreelancerProfileModel;

public interface FreelancerProfileDao {
    void saveOrUpdateProfile(FreelancerProfileModel profile);
    FreelancerProfileModel getProfileByFreelancerId(int freelancerId);
}