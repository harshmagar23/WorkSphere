package com.service;

import com.model.FreelancerProfileModel;

public interface FreelancerProfileService {
    void saveOrUpdateProfile(FreelancerProfileModel profile);
    FreelancerProfileModel getProfileByFreelancerId(int freelancerId);
}