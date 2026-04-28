package com.dao;

import com.model.ClientModel;

public interface ClientDao {

    public void saveUser(ClientModel model);

    public ClientModel loginClient(String email, String password);

    public ClientModel getByEmail(String email);

    public ClientModel getClientById(int clientId);

    public void updateClientProfile(ClientModel client);

    public void updatePassword(String email, String password);
}
