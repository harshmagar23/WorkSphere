package com.model;

import javax.persistence.*;

@Entity
@Table(name = "freelancer_profile")
public class FreelancerProfileModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "profile_id")
    private int profileId;

    @Column(name = "freelancer_id", unique = true, nullable = false)
    private int freelancerId;

    @Column(name = "professional_title")
    private String professionalTitle;

    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;

    @Column(name = "skills")
    private String skills;

    @Column(name = "experience_years")
    private int experienceYears;

    @Column(name = "hourly_rate")
    private double hourlyRate;

    @Column(name = "profile_image")
    private String profileImage;

    public FreelancerProfileModel() {
        super();
    }

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public int getFreelancerId() {
        return freelancerId;
    }

    public void setFreelancerId(int freelancerId) {
        this.freelancerId = freelancerId;
    }

    public String getProfessionalTitle() {
        return professionalTitle;
    }

    public void setProfessionalTitle(String professionalTitle) {
        this.professionalTitle = professionalTitle;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public int getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }

    public double getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(double hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }
}