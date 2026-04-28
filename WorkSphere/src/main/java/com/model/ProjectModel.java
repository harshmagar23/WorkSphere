package com.model;

import javax.persistence.*;

@Entity
@Table(name = "project")
public class ProjectModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String title;

    @Column(length = 2000)
    private String description;

    private double budget;

    private String deadline;

    private String status;

    @Column(length = 3000)
    private String submissionMessage;

    private String submissionDate;

    private String submissionOriginalFileName; 

    private String submissionStoredFileName;

    private String submissionFileType;

    private long submissionFileSize;

    @Column(length = 3000)
    private String revisionMessage;

    private String revisionRequestedDate;

    private int revisionCount;

    private String cancelledAt;

    @Column(length = 1000)
    private String cancellationReason;

    private String updatedAt;

    @ManyToOne
    @JoinColumn(name = "client_id")
    private ClientModel client;

    @ManyToOne
    @JoinColumn(name = "assigned_freelancer_id")
    private FreelancerModel assignedFreelancer;

    public ProjectModel() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public String getDeadline() {
        return deadline;
    }

    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSubmissionMessage() {
        return submissionMessage;
    }

    public void setSubmissionMessage(String submissionMessage) {
        this.submissionMessage = submissionMessage;
    }

    public String getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(String submissionDate) {
        this.submissionDate = submissionDate;
    }

    public String getSubmissionOriginalFileName() {
        return submissionOriginalFileName;
    }

    public void setSubmissionOriginalFileName(String submissionOriginalFileName) {
        this.submissionOriginalFileName = submissionOriginalFileName;
    }

    public String getSubmissionStoredFileName() {
        return submissionStoredFileName;
    }

    public void setSubmissionStoredFileName(String submissionStoredFileName) {
        this.submissionStoredFileName = submissionStoredFileName;
    }

    public String getSubmissionFileType() {
        return submissionFileType;
    }

    public void setSubmissionFileType(String submissionFileType) {
        this.submissionFileType = submissionFileType;
    }

    public long getSubmissionFileSize() {
        return submissionFileSize;
    }

    public void setSubmissionFileSize(long submissionFileSize) {
        this.submissionFileSize = submissionFileSize;
    }

    public String getRevisionMessage() {
        return revisionMessage;
    }

    public void setRevisionMessage(String revisionMessage) {
        this.revisionMessage = revisionMessage;
    }

    public String getRevisionRequestedDate() {
        return revisionRequestedDate;
    }

    public void setRevisionRequestedDate(String revisionRequestedDate) {
        this.revisionRequestedDate = revisionRequestedDate;
    }

    public int getRevisionCount() {
        return revisionCount;
    }

    public void setRevisionCount(int revisionCount) {
        this.revisionCount = revisionCount;
    }

    public String getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(String cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public ClientModel getClient() {
        return client;
    }

    public void setClient(ClientModel client) {
        this.client = client;
    }

    public FreelancerModel getAssignedFreelancer() {
        return assignedFreelancer;
    }

    public void setAssignedFreelancer(FreelancerModel assignedFreelancer) {
        this.assignedFreelancer = assignedFreelancer;
    }
}
