package com.service;

import com.model.ClientModel;

public interface ClientService {

    public void saveUser(ClientModel model);

    public ClientModel loginClient(String email, String password);

    public boolean checkEmailExists(String email);

    public ClientModel getClientById(int clientId);

    public void updateClientProfile(ClientModel client);

    public void updatePassword(String email, String password);
}
