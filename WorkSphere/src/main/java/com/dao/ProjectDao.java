package com.dao;

import java.util.List;
import com.model.ProjectModel;

public interface ProjectDao {

    public void saveProject(ProjectModel project);

    public List<ProjectModel> getProjectsByClientId(int clientId);

    public List<ProjectModel> getAllProjects();

    public ProjectModel getProjectById(int projectId);

    public void updateProject(ProjectModel project);

    public List<ProjectModel> getProjectsByAssignedFreelancerId(int freelancerId);

    public long countProjectsByClient(int clientId);

    public long countProjectsByClientAndStatus(int clientId, String status);

    public long countProjectsByFreelancer(int freelancerId);

    public long countCompletedProjectsByFreelancer(int freelancerId);

    public List<ProjectModel> getOpenProjectsForMarketplace(String search, String sort, int offset, int limit);

    public long countOpenProjectsForMarketplace(String search);

    public List<ProjectModel> getClientProjectsForWorkspace(int clientId, String search, String status, String sort, int offset, int limit);

    public long countClientProjectsForWorkspace(int clientId, String search, String status);
}
