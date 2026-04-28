package com.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.model.SavedProjectModel;

@Repository
@Transactional
public class SavedProjectDaoImpl implements SavedProjectDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveSavedProject(SavedProjectModel savedProject) {
        sessionFactory.getCurrentSession().save(savedProject);
    }

    @Override
    public void deleteSavedProject(SavedProjectModel savedProject) {
        sessionFactory.getCurrentSession().delete(savedProject);
    }

    @Override
    public SavedProjectModel getSavedProjectById(int savedProjectId) {
        return sessionFactory.getCurrentSession()
                .createQuery("select distinct sp from SavedProjectModel sp left join fetch sp.project p left join fetch p.client left join fetch sp.freelancer where sp.id = :savedProjectId", SavedProjectModel.class)
                .setParameter("savedProjectId", savedProjectId)
                .uniqueResult();
    }

    @Override
    public SavedProjectModel getSavedProjectByFreelancerAndProject(int freelancerId, int projectId) {
        return sessionFactory.getCurrentSession()
                .createQuery("from SavedProjectModel sp where sp.freelancer.id = :freelancerId and sp.project.id = :projectId", SavedProjectModel.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("projectId", projectId)
                .setMaxResults(1)
                .uniqueResult();
    }

    @Override
    public boolean isProjectSaved(int freelancerId, int projectId) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(*) from SavedProjectModel sp where sp.freelancer.id = :freelancerId and sp.project.id = :projectId", Long.class)
                .setParameter("freelancerId", freelancerId)
                .setParameter("projectId", projectId)
                .uniqueResult();

        return count != null && count > 0;
    }

    @Override
    public List<Integer> getSavedProjectIdsByFreelancer(int freelancerId) {
        return sessionFactory.getCurrentSession()
                .createQuery("select sp.project.id from SavedProjectModel sp where sp.freelancer.id = :freelancerId", Integer.class)
                .setParameter("freelancerId", freelancerId)
                .getResultList();
    }

    @Override
    public List<SavedProjectModel> getSavedProjectsByFreelancer(int freelancerId, String search, String sort, int offset, int limit) {
        Session session = sessionFactory.getCurrentSession();

        StringBuilder hql = new StringBuilder(
                "select distinct sp from SavedProjectModel sp "
                        + "left join fetch sp.project p "
                        + "left join fetch p.client "
                        + "where sp.freelancer.id = :freelancerId"
        );

        boolean hasSearch = search != null && search.trim().length() > 0;

        if (hasSearch) {
            hql.append(" and (lower(p.title) like :keyword or lower(p.description) like :keyword or lower(p.status) like :keyword or lower(p.client.name) like :keyword)");
        }

        hql.append(getOrderBy(sort));

        Query<SavedProjectModel> query = session.createQuery(hql.toString(), SavedProjectModel.class);
        query.setParameter("freelancerId", freelancerId);

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
    public long countSavedProjectsByFreelancer(int freelancerId, String search) {
        StringBuilder hql = new StringBuilder(
                "select count(distinct sp.id) from SavedProjectModel sp "
                        + "join sp.project p "
                        + "left join p.client c "
                        + "where sp.freelancer.id = :freelancerId"
        );

        boolean hasSearch = search != null && search.trim().length() > 0;

        if (hasSearch) {
            hql.append(" and (lower(p.title) like :keyword or lower(p.description) like :keyword or lower(p.status) like :keyword or lower(c.name) like :keyword)");
        }

        Query<Long> query = sessionFactory.getCurrentSession().createQuery(hql.toString(), Long.class);
        query.setParameter("freelancerId", freelancerId);

        if (hasSearch) {
            query.setParameter("keyword", "%" + search.trim().toLowerCase() + "%");
        }

        Long count = query.uniqueResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countSavedProjectsByFreelancer(int freelancerId) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(*) from SavedProjectModel sp where sp.freelancer.id = :freelancerId", Long.class)
                .setParameter("freelancerId", freelancerId)
                .uniqueResult();

        return count == null ? 0 : count;
    }

    private String getOrderBy(String sort) {
        if (sort == null) {
            return " order by sp.id desc";
        }

        String s = sort.trim().toLowerCase();

        if ("budgethigh".equals(s)) {
            return " order by p.budget desc, sp.id desc";
        }

        if ("budgetlow".equals(s)) {
            return " order by p.budget asc, sp.id desc";
        }

        if ("deadline".equals(s)) {
            return " order by p.deadline asc, sp.id desc";
        }

        if ("projectaz".equals(s)) {
            return " order by p.title asc, sp.id desc";
        }

        if ("status".equals(s)) {
            return " order by p.status asc, sp.id desc";
        }

        return " order by sp.id desc";
    }
}
