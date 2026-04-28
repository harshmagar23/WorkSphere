package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.FreelancerDao;
import com.model.FreelancerModel;

@Service
@Transactional
public class FreelancerServiceImpl implements FreelancerService {

    @Autowired
    private FreelancerDao freelancerDao;

    @Override
    public void saveFreelancer(FreelancerModel freelance) {
        freelancerDao.saveFreelancer(freelance);
    }

    @Override
    @Transactional(readOnly = true)
    public FreelancerModel loginFreelancer(String email, String password) {
        return freelancerDao.loginFreelancer(email, password);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean checkEmailExists(String email) {
        return freelancerDao.getByEmail(email) != null;
    }

    @Override
    public void updatePassword(String email, String password) {
        freelancerDao.updatePassword(email, password);
    }
}
