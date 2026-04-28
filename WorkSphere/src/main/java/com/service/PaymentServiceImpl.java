package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.PaymentDao;
import com.model.PaymentModel;

@Service
@Transactional
public class PaymentServiceImpl implements PaymentService {

    private static final double PLATFORM_FEE_RATE = 0.05;

    @Autowired
    private PaymentDao paymentDao;

    @Override
    public void savePayment(PaymentModel payment) { paymentDao.savePayment(payment); }

    @Override
    public void updatePayment(PaymentModel payment) { paymentDao.updatePayment(payment); }

    @Override
    @Transactional(readOnly = true)
    public PaymentModel getPaymentById(int paymentId) { return paymentDao.getPaymentById(paymentId); }

    @Override
    @Transactional(readOnly = true)
    public PaymentModel getPaymentByProjectId(int projectId) { return paymentDao.getPaymentByProjectId(projectId); }

    @Override
    @Transactional(readOnly = true)
    public PaymentModel getPaymentByBidId(int bidId) { return paymentDao.getPaymentByBidId(bidId); }

    @Override
    @Transactional(readOnly = true)
    public List<PaymentModel> getPaymentsByClientId(int clientId) { return paymentDao.getPaymentsByClientId(clientId); }

    @Override
    @Transactional(readOnly = true)
    public List<PaymentModel> getPaymentsByFreelancerId(int freelancerId) { return paymentDao.getPaymentsByFreelancerId(freelancerId); }

    @Override
    @Transactional(readOnly = true)
    public long countPaymentsByClientAndStatus(int clientId, String status) { return paymentDao.countPaymentsByClientAndStatus(clientId, status); }

    @Override
    @Transactional(readOnly = true)
    public long countPaymentsByFreelancerAndStatus(int freelancerId, String status) { return paymentDao.countPaymentsByFreelancerAndStatus(freelancerId, status); }

    @Override
    @Transactional(readOnly = true)
    public double sumFreelancerReleasedAmount(int freelancerId) { return paymentDao.sumFreelancerReleasedAmount(freelancerId); }

    @Override
    public double calculatePlatformFee(double bidAmount) {
        if (bidAmount <= 0) return 0.0;
        return Math.round((bidAmount * PLATFORM_FEE_RATE) * 100.0) / 100.0;
    }

    @Override
    public double calculateTotalAmount(double bidAmount) {
        return Math.round((bidAmount + calculatePlatformFee(bidAmount)) * 100.0) / 100.0;
    }
}
