package com.model;

import javax.persistence.*;

@Entity
@Table(
    name = "saved_project",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"freelancer_id", "project_id"})
    }
)
public class SavedProjectModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String savedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "freelancer_id")
    private FreelancerModel freelancer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id")
    private ProjectModel project;

    public SavedProjectModel() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 

    public String getSavedAt() {
        return savedAt;
    }

    public void setSavedAt(String savedAt) {
        this.savedAt = savedAt;
    }

    public FreelancerModel getFreelancer() {
        return freelancer;
    }

    public void setFreelancer(FreelancerModel freelancer) {
        this.freelancer = freelancer;
    }

    public ProjectModel getProject() {
        return project;
    }

    public void setProject(ProjectModel project) {
        this.project = project;
    }
}
