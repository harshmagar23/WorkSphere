package com.model;

import javax.persistence.*;

@Entity
@Table(name = "project_payment")
public class PaymentModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "project_id")
    private ProjectModel project;

    @ManyToOne
    @JoinColumn(name = "bid_id")
    private BidModel bid;

    @ManyToOne
    @JoinColumn(name = "client_id")
    private ClientModel client;

    @ManyToOne
    @JoinColumn(name = "freelancer_id")
    private FreelancerModel freelancer;

    private double bidAmount;
    private double platformFee;
    private double totalAmount;
    private double freelancerAmount;

    private String paymentStatus;
    private String paymentMethod;
    private String transactionId;
    private String paidAt;
    private String releasedAt;
    private String refundedAt;

    @Column(length = 1000)
    private String refundReason;
    private String createdAt;
    private String updatedAt;

    public PaymentModel(){}

    public int getId(){ return id; }
    public void setId(int id){ this.id = id; }
    public ProjectModel getProject(){ return project; }
    public void setProject(ProjectModel project){ this.project = project; }
    public BidModel getBid(){ return bid; }
    public void setBid(BidModel bid){ this.bid = bid; }
    public ClientModel getClient(){ return client; }
    public void setClient(ClientModel client){ this.client = client; }
    public FreelancerModel getFreelancer(){ return freelancer; }
    public void setFreelancer(FreelancerModel freelancer){ this.freelancer = freelancer; }
    public double getBidAmount(){ return bidAmount; }
    public void setBidAmount(double bidAmount){ this.bidAmount = bidAmount; }
    public double getPlatformFee(){ return platformFee; }
    public void setPlatformFee(double platformFee){ this.platformFee = platformFee; }
    public double getTotalAmount(){ return totalAmount; }
    public void setTotalAmount(double totalAmount){ this.totalAmount = totalAmount; }
    public double getFreelancerAmount(){ return freelancerAmount; }
    public void setFreelancerAmount(double freelancerAmount){ this.freelancerAmount = freelancerAmount; }
    public String getPaymentStatus(){ return paymentStatus; }
    public void setPaymentStatus(String paymentStatus){ this.paymentStatus = paymentStatus; }
    public String getPaymentMethod(){ return paymentMethod; }
    public void setPaymentMethod(String paymentMethod){ this.paymentMethod = paymentMethod; }
    public String getTransactionId(){ return transactionId; }
    public void setTransactionId(String transactionId){ this.transactionId = transactionId; }
    public String getPaidAt(){ return paidAt; }
    public void setPaidAt(String paidAt){ this.paidAt = paidAt; }
    public String getReleasedAt(){ return releasedAt; }
    public void setReleasedAt(String releasedAt){ this.releasedAt = releasedAt; }
    public String getRefundedAt(){ return refundedAt; }
    public void setRefundedAt(String refundedAt){ this.refundedAt = refundedAt; }
    public String getRefundReason(){ return refundReason; }
    public void setRefundReason(String refundReason){ this.refundReason = refundReason; }
    public String getCreatedAt(){ return createdAt; }
    public void setCreatedAt(String createdAt){ this.createdAt = createdAt; }
    public String getUpdatedAt(){ return updatedAt; }
    public void setUpdatedAt(String updatedAt){ this.updatedAt = updatedAt; }
}
