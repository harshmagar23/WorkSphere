package com.dao;

import com.model.FreelancerModel;

public interface FreelancerDao {

    public void saveFreelancer(FreelancerModel freelance);

    public FreelancerModel loginFreelancer(String email, String password);

    public FreelancerModel getByEmail(String email);

    public void updatePassword(String email, String password);
}
