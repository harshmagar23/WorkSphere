package com.service;

import com.model.FreelancerModel;

public interface FreelancerService {

    public void saveFreelancer(FreelancerModel freelance);

    public FreelancerModel loginFreelancer(String email, String password);

    public boolean checkEmailExists(String email);

    public void updatePassword(String email, String password);
}
