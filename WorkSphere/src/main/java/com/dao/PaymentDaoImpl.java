package com.dao;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.model.PaymentModel;

@Repository
@Transactional
public class PaymentDaoImpl implements PaymentDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void savePayment(PaymentModel payment) {
        sessionFactory.getCurrentSession().save(payment);
    }

    @Override
    public void updatePayment(PaymentModel payment) {
        sessionFactory.getCurrentSession().update(payment);
    }

    @Override
    public PaymentModel getPaymentById(int paymentId) {
        return sessionFactory.getCurrentSession()
                .createQuery("select distinct p from PaymentModel p left join fetch p.project left join fetch p.client left join fetch p.freelancer left join fetch p.bid where p.id = :paymentId", PaymentModel.class)
                .setParameter("paymentId", paymentId)
                .uniqueResult();
    }

    @Override
    public PaymentModel getPaymentByProjectId(int projectId) {
        return sessionFactory.getCurrentSession()
                .createQuery("select distinct p from PaymentModel p left join fetch p.project left join fetch p.client left join fetch p.freelancer left join fetch p.bid where p.project.id = :projectId order by p.id desc", PaymentModel.class)
                .setParameter("projectId", projectId)
                .setMaxResults(1)
                .uniqueResult();
    }

    @Override
    public PaymentModel getPaymentByBidId(int bidId) {
        return sessionFactory.getCurrentSession()
                .createQuery("from PaymentModel where bid.id = :bidId order by id desc", PaymentModel.class)
                .setParameter("bidId", bidId)
                .setMaxResults(1)
                .uniqueResult();
    }

    @Override
    public List<PaymentModel> getPaymentsByClientId(int clientId) {
        return sessionFactory.getCurrentSession()
                .createQuery("select distinct p from PaymentModel p left join fetch p.project left join fetch p.freelancer where p.client.id = :clientId order by p.id desc", PaymentModel.class)
                .setParameter("clientId", clientId)
                .getResultList();
    }

    @Override
    public List<PaymentModel> getPaymentsByFreelancerId(int freelancerId) {
        return sessionFactory.getCurrentSession()
                .createQuery("select distinct p from PaymentModel p left join fetch p.project left join fetch p.client where p.freelancer.id = :freelancerId order by p.id desc", PaymentModel.class)
                .setParameter("freelancerId", freelancerId)
                .getResultList();
    }

    @Override
    public long countPaymentsByClientAndStatus(int clientId, String status) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(*) from PaymentModel where client.id = :clientId and lower(paymentStatus) = :status", Long.class)
                .setParameter("clientId", clientId)
                .setParameter("status", status == null ? "" : status.toLowerCase())
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countPaymentsByFreelancerAndStatus(int freelancerId, String status) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(*) from PaymentModel where freelancer.id = :freelancerId and lower(paymentStatus) = :status", Long.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("status", status == null ? "" : status.toLowerCase())
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public double sumFreelancerReleasedAmount(int freelancerId) {
        Double total = sessionFactory.getCurrentSession()
                .createQuery("select sum(freelancerAmount) from PaymentModel where freelancer.id = :freelancerId and lower(paymentStatus) = :status", Double.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("status", "released")
                .uniqueResult();
        return total == null ? 0.0 : total;
    }
}
