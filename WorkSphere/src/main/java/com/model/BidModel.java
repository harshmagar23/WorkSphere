package com.model;

import javax.persistence.*;

@Entity
@Table(name = "bid")
public class BidModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private double bidAmount;

    @Column(length = 2000)
    private String proposalText;

    private String status;

    private String updatedAt;

    private String withdrawnAt;

    @Column(length = 1000)
    private String withdrawalReason;

    @ManyToOne
    @JoinColumn(name = "freelancer_id")
    private FreelancerModel freelancer;

    @ManyToOne
    @JoinColumn(name = "project_id")
    private ProjectModel project;

    public BidModel() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 

    public double getBidAmount() {
        return bidAmount;
    }

    public void setBidAmount(double bidAmount) {
        this.bidAmount = bidAmount;
    }

    public String getProposalText() {
        return proposalText;
    }

    public void setProposalText(String proposalText) {
        this.proposalText = proposalText;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getWithdrawnAt() {
        return withdrawnAt;
    }

    public void setWithdrawnAt(String withdrawnAt) {
        this.withdrawnAt = withdrawnAt;
    }

    public String getWithdrawalReason() {
        return withdrawalReason;
    }

    public void setWithdrawalReason(String withdrawalReason) {
        this.withdrawalReason = withdrawalReason;
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