package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.ProjectDao;
import com.model.ProjectModel;

@Service
@Transactional
public class ProjectServiceImpl implements ProjectService {

    @Autowired
    private ProjectDao projectDao;

    @Override
    public void saveProject(ProjectModel project) {
        projectDao.saveProject(project);
    }

    @Override
    public List<ProjectModel> getProjectsByClientId(int clientId) {
        return projectDao.getProjectsByClientId(clientId);
    }

    @Override
    public List<ProjectModel> getAllProjects() {
        return projectDao.getAllProjects();
    }

    @Override
    public ProjectModel getProjectById(int projectId) {
        return projectDao.getProjectById(projectId);
    }

    @Override
    public void updateProject(ProjectModel project) {
        projectDao.updateProject(project);
    }

    @Override
    public List<ProjectModel> getProjectsByAssignedFreelancerId(int freelancerId) {
        return projectDao.getProjectsByAssignedFreelancerId(freelancerId);
    }

    @Override
    public long countProjectsByClient(int clientId) {
        return projectDao.countProjectsByClient(clientId);
    }

    @Override
    public long countProjectsByClientAndStatus(int clientId, String status) {
        return projectDao.countProjectsByClientAndStatus(clientId, status);
    }

    @Override
    public long countProjectsByFreelancer(int freelancerId) {
        return projectDao.countProjectsByFreelancer(freelancerId);
    }

    @Override
    public long countCompletedProjectsByFreelancer(int freelancerId) {
        return projectDao.countCompletedProjectsByFreelancer(freelancerId);
    }

    @Override
    public List<ProjectModel> getOpenProjectsForMarketplace(String search, String sort, int offset, int limit) {
        return projectDao.getOpenProjectsForMarketplace(search, sort, offset, limit);
    }

    @Override
    public long countOpenProjectsForMarketplace(String search) {
        return projectDao.countOpenProjectsForMarketplace(search);
    }

    @Override
    public List<ProjectModel> getClientProjectsForWorkspace(int clientId, String search, String status, String sort, int offset, int limit) {
        return projectDao.getClientProjectsForWorkspace(clientId, search, status, sort, offset, limit);
    }

    @Override
    public long countClientProjectsForWorkspace(int clientId, String search, String status) {
        return projectDao.countClientProjectsForWorkspace(clientId, search, status);
    }

}
