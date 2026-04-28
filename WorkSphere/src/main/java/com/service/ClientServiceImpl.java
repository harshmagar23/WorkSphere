package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.ClientDao;
import com.model.ClientModel;

@Service
public class ClientServiceImpl implements ClientService {

    @Autowired
    private ClientDao clientDao;

    @Override
    @Transactional
    public void saveUser(ClientModel model) {
        clientDao.saveUser(model);
    }

    @Override
    @Transactional(readOnly = true)
    public ClientModel loginClient(String email, String password) {
        return clientDao.loginClient(email, password);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean checkEmailExists(String email) {
        return clientDao.getByEmail(email) != null;
    }

    @Override
    @Transactional(readOnly = true)
    public ClientModel getClientById(int clientId) {
        return clientDao.getClientById(clientId);
    }

    @Override
    @Transactional
    public void updateClientProfile(ClientModel client) {
        clientDao.updateClientProfile(client);
    }

    @Override
    @Transactional
    public void updatePassword(String email, String password) {
        clientDao.updatePassword(email, password);
    }
}
