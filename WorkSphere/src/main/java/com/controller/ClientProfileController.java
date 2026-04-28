package com.controller;

import java.time.LocalDateTime;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.model.ClientModel;
import com.service.ClientService;

@Controller
public class ClientProfileController {

    @Autowired
    private ClientService clientService;

    private String clean(String value, int maxLength) {
        if (value == null) {
            return "";
        }

        String cleaned = value.trim();

        if (cleaned.length() > maxLength) {
            cleaned = cleaned.substring(0, maxLength);
        }

        return cleaned;
    }

    private ClientModel getLoggedClient(HttpSession session) {
        ClientModel sessionClient = (ClientModel) session.getAttribute("clientSession");

        if (sessionClient == null) {
            return null;
        }

        ClientModel freshClient = clientService.getClientById(sessionClient.getId());

        if (freshClient != null) {
            session.setAttribute("clientSession", freshClient);
        }

        return freshClient;
    }

    @GetMapping("/clientProfile")
    public String clientProfile(HttpSession session, Model model) {
        ClientModel client = getLoggedClient(session);

        if (client == null) {
            return "redirect:/clientLogin";
        }

        model.addAttribute("client", client);
        return "clientProfile";
    }

    @GetMapping("/editClientProfile")
    public String editClientProfile(HttpSession session, Model model) {
        ClientModel client = getLoggedClient(session);

        if (client == null) {
            return "redirect:/clientLogin";
        }

        model.addAttribute("client", client);
        return "editClientProfile";
    }

    @PostMapping("/updateClientProfile")
    public String updateClientProfile(@RequestParam("name") String name,
                                      @RequestParam(value = "mobile", required = false) String mobile,
                                      @RequestParam(value = "company", required = false) String company,
                                      @RequestParam(value = "website", required = false) String website,
                                      @RequestParam(value = "industry", required = false) String industry,
                                      @RequestParam(value = "address", required = false) String address,
                                      @RequestParam(value = "city", required = false) String city,
                                      @RequestParam(value = "state", required = false) String state,
                                      @RequestParam(value = "country", required = false) String country,
                                      @RequestParam(value = "zipcode", required = false) String zipcode,
                                      @RequestParam(value = "bio", required = false) String bio,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {

        ClientModel client = getLoggedClient(session);

        if (client == null) {
            return "redirect:/clientLogin";
        }

        String cleanName = clean(name, 120);

        if (cleanName.length() == 0) {
            redirectAttributes.addFlashAttribute("warning", "Client name is required.");
            return "redirect:/editClientProfile";
        }

        client.setName(cleanName);
        client.setMobile(clean(mobile, 30));
        client.setCompany(clean(company, 150));
        client.setWebsite(clean(website, 180));
        client.setIndustry(clean(industry, 120));
        client.setAddress(clean(address, 255));
        client.setCity(clean(city, 100));
        client.setState(clean(state, 100));
        client.setCountry(clean(country, 100));
        client.setZipcode(clean(zipcode, 30));
        client.setBio(clean(bio, 1000));
        client.setUpdatedAt(LocalDateTime.now().toString());

        clientService.updateClientProfile(client);
        session.setAttribute("clientSession", client);

        redirectAttributes.addFlashAttribute("success", "Client profile updated successfully.");
        return "redirect:/clientProfile";
    }
}
