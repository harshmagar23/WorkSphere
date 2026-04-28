package com.dao;

import java.util.List;

import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.model.BidModel;

@Repository
@Transactional
public class BidDaoImpl implements BidDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveBid(BidModel bid) {
        sessionFactory.getCurrentSession().save(bid);
    }

    @Override
    public List<BidModel> getBidsByFreelancerId(int freelancerId) {
        String hql = "select b from BidModel b "
                + "join fetch b.project p "
                + "left join fetch p.client c "
                + "where b.freelancer.id = :freelancerId "
                + "order by b.id desc";

        return sessionFactory.getCurrentSession()
                .createQuery(hql, BidModel.class)
                .setParameter("freelancerId", freelancerId)
                .getResultList();
    }

    @Override
    public List<BidModel> getBidsByProjectId(int projectId) {
        String hql = "from BidModel where project.id = :projectId order by id desc";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, BidModel.class)
                .setParameter("projectId", projectId)
                .getResultList();
    }

    @Override
    public BidModel getBidById(int bidId) {
        return sessionFactory.getCurrentSession().get(BidModel.class, bidId);
    }

    @Override
    public void updateBid(BidModel bid) {
        sessionFactory.getCurrentSession().update(bid);
    }

    @Override
    public BidModel getBidByProjectAndFreelancer(int projectId, int freelancerId) {
        String hql = "from BidModel where project.id = :projectId and freelancer.id = :freelancerId "
                + "and lower(status) <> :withdrawn order by id desc";
        List<BidModel> list = sessionFactory.getCurrentSession()
                .createQuery(hql, BidModel.class)
                .setParameter("projectId", projectId)
                .setParameter("freelancerId", freelancerId)
                .setParameter("withdrawn", "withdrawn")
                .getResultList();

        if (list != null && !list.isEmpty()) {
            return list.get(0);
        }

        return null;
    }

    @Override
    public long countBidsByFreelancer(int freelancerId) {
        String hql = "select count(b.id) from BidModel b join b.project p where b.freelancer.id = :freelancerId";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("freelancerId", freelancerId)
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countAcceptedBidsByFreelancer(int freelancerId) {
        String hql = "select count(b.id) from BidModel b join b.project p "
                + "where b.freelancer.id = :freelancerId and lower(b.status) = :status";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("status", "accepted")
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countBidsByClientProjects(int clientId) {
        String hql = "select count(*) from BidModel where project.client.id = :clientId";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("clientId", clientId)
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public List<BidModel> searchBidsByFreelancer(int freelancerId,
                                                 String keyword,
                                                 String status,
                                                 String sort,
                                                 int page,
                                                 int size) {

        StringBuilder hql = new StringBuilder();
        hql.append("select b from BidModel b ");
        hql.append("join fetch b.project p ");
        hql.append("left join fetch p.client c ");
        hql.append("where b.freelancer.id = :freelancerId ");

        boolean hasKeyword = keyword != null && keyword.trim().length() > 0;
        boolean hasStatus = status != null && status.trim().length() > 0 && !"all".equalsIgnoreCase(status);

        if (hasKeyword) {
            hql.append("and (lower(p.title) like :keyword ");
            hql.append("or lower(p.description) like :keyword ");
            hql.append("or lower(b.proposalText) like :keyword ");
            hql.append("or lower(b.status) like :keyword ");
            hql.append("or lower(c.name) like :keyword) ");
        }

        if (hasStatus) {
            hql.append("and lower(b.status) = :status ");
        }

        hql.append(resolveSort(sort));

        Query<BidModel> query = sessionFactory.getCurrentSession().createQuery(hql.toString(), BidModel.class);
        query.setParameter("freelancerId", freelancerId);

        if (hasKeyword) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }

        if (hasStatus) {
            query.setParameter("status", normalizeStatus(status));
        }

        if (page < 1) {
            page = 1;
        }

        if (size < 1) {
            size = 8;
        }

        query.setFirstResult((page - 1) * size);
        query.setMaxResults(size);

        return query.getResultList();
    }

    @Override
    public long countSearchBidsByFreelancer(int freelancerId,
                                            String keyword,
                                            String status) {

        StringBuilder hql = new StringBuilder();
        hql.append("select count(b.id) from BidModel b ");
        hql.append("join b.project p ");
        hql.append("left join p.client c ");
        hql.append("where b.freelancer.id = :freelancerId ");

        boolean hasKeyword = keyword != null && keyword.trim().length() > 0;
        boolean hasStatus = status != null && status.trim().length() > 0 && !"all".equalsIgnoreCase(status);

        if (hasKeyword) {
            hql.append("and (lower(p.title) like :keyword ");
            hql.append("or lower(p.description) like :keyword ");
            hql.append("or lower(b.proposalText) like :keyword ");
            hql.append("or lower(b.status) like :keyword ");
            hql.append("or lower(c.name) like :keyword) ");
        }

        if (hasStatus) {
            hql.append("and lower(b.status) = :status ");
        }

        Query<Long> query = sessionFactory.getCurrentSession().createQuery(hql.toString(), Long.class);
        query.setParameter("freelancerId", freelancerId);

        if (hasKeyword) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }

        if (hasStatus) {
            query.setParameter("status", normalizeStatus(status));
        }

        Long count = query.uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countBidsByFreelancerAndStatus(int freelancerId, String status) {
        String hql = "select count(b.id) from BidModel b join b.project p "
                + "where b.freelancer.id = :freelancerId and lower(b.status) = :status";

        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("status", normalizeStatus(status))
                .uniqueResult();

        return count == null ? 0 : count;
    }

    private String normalizeStatus(String status) {
        if (status == null) {
            return "pending";
        }

        String s = status.trim().toLowerCase();

        if (s.contains("accept")) {
            return "accepted";
        }

        if (s.contains("reject") || s.contains("decline")) {
            return "rejected";
        }

        if (s.contains("withdraw")) {
            return "withdrawn";
        }

        return "pending";
    }

    private String resolveSort(String sort) {
        if (sort == null) {
            return "order by b.id desc";
        }

        String s = sort.trim().toLowerCase();

        if ("amounthigh".equals(s)) {
            return "order by b.bidAmount desc, b.id desc";
        }

        if ("amountlow".equals(s)) {
            return "order by b.bidAmount asc, b.id desc";
        }

        if ("projectaz".equals(s)) {
            return "order by lower(p.title) asc, b.id desc";
        }

        if ("status".equals(s)) {
            return "order by lower(b.status) asc, b.id desc";
        }

        return "order by b.id desc";
    }
}
