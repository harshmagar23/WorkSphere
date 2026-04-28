package com.service;

import java.util.List;
import com.model.PaymentModel;

public interface PaymentService {
    public void savePayment(PaymentModel payment);
    public void updatePayment(PaymentModel payment);
    public PaymentModel getPaymentById(int paymentId);
    public PaymentModel getPaymentByProjectId(int projectId);
    public PaymentModel getPaymentByBidId(int bidId);
    public List<PaymentModel> getPaymentsByClientId(int clientId);
    public List<PaymentModel> getPaymentsByFreelancerId(int freelancerId);
    public long countPaymentsByClientAndStatus(int clientId, String status);
    public long countPaymentsByFreelancerAndStatus(int freelancerId, String status);
    public double sumFreelancerReleasedAmount(int freelancerId);
    public double calculatePlatformFee(double bidAmount);
    public double calculateTotalAmount(double bidAmount);
}
