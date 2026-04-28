package com.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.model.ClientModel;

@Repository
public class ClientDaoImpl implements ClientDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveUser(ClientModel model) {
        sessionFactory.getCurrentSession().save(model);
    }

    @Override
    public ClientModel loginClient(String email, String password) {
        return sessionFactory.getCurrentSession()
                .createQuery("from ClientModel where lower(email)=:e and password=:p", ClientModel.class)
                .setParameter("e", email == null ? "" : email.trim().toLowerCase())
                .setParameter("p", password)
                .uniqueResult();
    }

    @Override
    public ClientModel getByEmail(String email) {
        return sessionFactory.getCurrentSession()
                .createQuery("from ClientModel where lower(email)=:email", ClientModel.class)
                .setParameter("email", email == null ? "" : email.trim().toLowerCase())
                .uniqueResult();
    }

    @Override
    public ClientModel getClientById(int clientId) {
        return sessionFactory.getCurrentSession().get(ClientModel.class, clientId);
    }

    @Override
    public void updateClientProfile(ClientModel client) {
        sessionFactory.getCurrentSession().update(client);
    }

    @Override
    public void updatePassword(String email, String password) {
        sessionFactory.getCurrentSession()
                .createQuery("update ClientModel set password=:p where lower(email)=:e")
                .setParameter("p", password)
                .setParameter("e", email == null ? "" : email.trim().toLowerCase())
                .executeUpdate();
    }
}
