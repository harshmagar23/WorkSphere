package com.service;

public interface EmailService {

    public boolean sendClientRegistrationSuccessEmail(String toEmail, String name);

    public boolean sendFreelancerRegistrationSuccessEmail(String toEmail, String name);
}
