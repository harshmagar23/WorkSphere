package com.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.model.ProjectModel;

@Repository
@Transactional
public class ProjectDaoImpl implements ProjectDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveProject(ProjectModel project) {
        sessionFactory.getCurrentSession().save(project);
    }

    @Override
    public List<ProjectModel> getProjectsByClientId(int clientId) {
        String hql = "from ProjectModel where client.id = :clientId order by id desc";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, ProjectModel.class)
                .setParameter("clientId", clientId)
                .getResultList();
    }

    @Override
    public List<ProjectModel> getAllProjects() {
        String hql = "from ProjectModel order by id desc";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, ProjectModel.class)
                .getResultList();
    }

    @Override
    public ProjectModel getProjectById(int projectId) {
        return sessionFactory.getCurrentSession().get(ProjectModel.class, projectId);
    }

    @Override
    public void updateProject(ProjectModel project) {
        sessionFactory.getCurrentSession().update(project);
    }

    @Override
    public List<ProjectModel> getProjectsByAssignedFreelancerId(int freelancerId) {
        String hql = "from ProjectModel where assignedFreelancer.id = :freelancerId order by id desc";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, ProjectModel.class)
                .setParameter("freelancerId", freelancerId)
                .getResultList();
    }

    @Override
    public long countProjectsByClient(int clientId) {
        String hql = "select count(*) from ProjectModel where client.id = :clientId";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("clientId", clientId)
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countProjectsByClientAndStatus(int clientId, String status) {
        String hql = "select count(*) from ProjectModel where client.id = :clientId and status = :status";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("clientId", clientId)
                .setParameter("status", status)
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countProjectsByFreelancer(int freelancerId) {
        String hql = "select count(*) from ProjectModel where assignedFreelancer.id = :freelancerId";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("freelancerId", freelancerId)
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countCompletedProjectsByFreelancer(int freelancerId) {
        String hql = "select count(*) from ProjectModel where assignedFreelancer.id = :freelancerId and status = :status";
        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("status", "Completed")
                .uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public List<ProjectModel> getOpenProjectsForMarketplace(String search, String sort, int offset, int limit) {
        Session session = sessionFactory.getCurrentSession();

        StringBuilder hql = new StringBuilder("select distinct p from ProjectModel p left join fetch p.client where lower(p.status) = :status");
        boolean hasSearch = search != null && search.trim().length() > 0;

        if (hasSearch) {
            hql.append(" and (lower(p.title) like :keyword or lower(p.description) like :keyword or lower(p.client.name) like :keyword)");
        }

        hql.append(getMarketplaceOrderBy(sort));

        Query<ProjectModel> query = session.createQuery(hql.toString(), ProjectModel.class);
        query.setParameter("status", "open");

        if (hasSearch) {
            query.setParameter("keyword", "%" + search.trim().toLowerCase() + "%");
        }

        if (offset < 0) {
            offset = 0;
        }

        if (limit <= 0) {
            limit = 8;
        }

        query.setFirstResult(offset);
        query.setMaxResults(limit);

        return query.getResultList();
    }

    @Override
    public long countOpenProjectsForMarketplace(String search) {
        Session session = sessionFactory.getCurrentSession();

        StringBuilder hql = new StringBuilder("select count(p.id) from ProjectModel p where lower(p.status) = :status");
        boolean hasSearch = search != null && search.trim().length() > 0;

        if (hasSearch) {
            hql.append(" and (lower(p.title) like :keyword or lower(p.description) like :keyword or lower(p.client.name) like :keyword)");
        }

        Query<Long> query = session.createQuery(hql.toString(), Long.class);
        query.setParameter("status", "open");

        if (hasSearch) {
            query.setParameter("keyword", "%" + search.trim().toLowerCase() + "%");
        }

        Long count = query.uniqueResult();
        return count == null ? 0 : count;
    }

    private String getMarketplaceOrderBy(String sort) {
        if (sort == null) {
            return " order by p.id desc";
        }

        if ("budgetHigh".equalsIgnoreCase(sort)) {
            return " order by p.budget desc, p.id desc";
        }

        if ("budgetLow".equalsIgnoreCase(sort)) {
            return " order by p.budget asc, p.id desc";
        }

        if ("deadlineSoon".equalsIgnoreCase(sort)) {
            return " order by p.deadline asc, p.id desc";
        }

        if ("titleAZ".equalsIgnoreCase(sort)) {
            return " order by lower(p.title) asc, p.id desc";
        }

        return " order by p.id desc";
    }

    @Override
    public List<ProjectModel> getClientProjectsForWorkspace(int clientId, String search, String status, String sort, int offset, int limit) {
        Session session = sessionFactory.getCurrentSession();

        StringBuilder hql = new StringBuilder("select distinct p from ProjectModel p left join fetch p.assignedFreelancer where p.client.id = :clientId");
        boolean hasSearch = search != null && search.trim().length() > 0;

        appendClientStatusFilter(hql, status);

        if (hasSearch) {
            hql.append(" and (lower(p.title) like :keyword or lower(p.description) like :keyword or lower(p.status) like :keyword or lower(p.assignedFreelancer.name) like :keyword)");
        }

        hql.append(getClientWorkspaceOrderBy(sort));

        Query<ProjectModel> query = session.createQuery(hql.toString(), ProjectModel.class);
        query.setParameter("clientId", clientId);
        bindClientStatusFilter(query, status);

        if (hasSearch) {
            query.setParameter("keyword", "%" + search.trim().toLowerCase() + "%");
        }

        if (offset < 0) {
            offset = 0;
        }

        if (limit <= 0) {
            limit = 6;
        }

        query.setFirstResult(offset);
        query.setMaxResults(limit);

        return query.getResultList();
    }

    @Override
    public long countClientProjectsForWorkspace(int clientId, String search, String status) {
        Session session = sessionFactory.getCurrentSession();

        StringBuilder hql = new StringBuilder("select count(distinct p.id) from ProjectModel p left join p.assignedFreelancer where p.client.id = :clientId");
        boolean hasSearch = search != null && search.trim().length() > 0;

        appendClientStatusFilter(hql, status);

        if (hasSearch) {
            hql.append(" and (lower(p.title) like :keyword or lower(p.description) like :keyword or lower(p.status) like :keyword or lower(p.assignedFreelancer.name) like :keyword)");
        }

        Query<Long> query = session.createQuery(hql.toString(), Long.class);
        query.setParameter("clientId", clientId);
        bindClientStatusFilter(query, status);

        if (hasSearch) {
            query.setParameter("keyword", "%" + search.trim().toLowerCase() + "%");
        }

        Long count = query.uniqueResult();
        return count == null ? 0 : count;
    }

    private void appendClientStatusFilter(StringBuilder hql, String status) {
        String s = status == null ? "all" : status.trim().toLowerCase();

        if (s.length() == 0 || "all".equals(s)) {
            return;
        }

        if ("open".equals(s)) {
            hql.append(" and lower(p.status) = :clientStatus");
            return;
        }

        if ("progress".equals(s) || "active".equals(s)) {
            hql.append(" and (lower(p.status) = :clientStatus or lower(p.status) = :clientPaymentStatus or lower(p.status) like :clientStatusLike)");
            return;
        }

        if ("submitted".equals(s)) {
            hql.append(" and lower(p.status) = :clientStatus");
            return;
        }

        if ("revision".equals(s) || "revision requested".equals(s)) {
            hql.append(" and lower(p.status) = :clientStatus");
            return;
        }

        if ("completed".equals(s)) {
            hql.append(" and lower(p.status) = :clientStatus");
        }
    }

    private void bindClientStatusFilter(Query<?> query, String status) {
        String s = status == null ? "all" : status.trim().toLowerCase();

        if (s.length() == 0 || "all".equals(s)) {
            return;
        }

        if ("open".equals(s)) {
            query.setParameter("clientStatus", "open");
            return;
        }

        if ("progress".equals(s) || "active".equals(s)) {
            query.setParameter("clientStatus", "in progress");
            query.setParameter("clientPaymentStatus", "payment pending");
            query.setParameter("clientStatusLike", "%assign%");
            return;
        }

        if ("submitted".equals(s)) {
            query.setParameter("clientStatus", "submitted");
            return;
        }

        if ("revision".equals(s) || "revision requested".equals(s)) {
            query.setParameter("clientStatus", "revision requested");
            return;
        }

        if ("completed".equals(s)) {
            query.setParameter("clientStatus", "completed");
        }
    }

    private String getClientWorkspaceOrderBy(String sort) {
        if (sort == null) {
            return " order by p.id desc";
        }

        if ("budgetHigh".equalsIgnoreCase(sort)) {
            return " order by p.budget desc, p.id desc";
        }

        if ("budgetLow".equalsIgnoreCase(sort)) {
            return " order by p.budget asc, p.id desc";
        }

        if ("deadlineSoon".equalsIgnoreCase(sort)) {
            return " order by p.deadline asc, p.id desc";
        }

        if ("titleAZ".equalsIgnoreCase(sort)) {
            return " order by lower(p.title) asc, p.id desc";
        }

        if ("status".equalsIgnoreCase(sort)) {
            return " order by lower(p.status) asc, p.id desc";
        }

        return " order by p.id desc";
    }

}
