package com.service;

import java.util.List;
import com.model.SavedProjectModel;

public interface SavedProjectService {

    public void saveSavedProject(SavedProjectModel savedProject);

    public void deleteSavedProject(SavedProjectModel savedProject);

    public SavedProjectModel getSavedProjectById(int savedProjectId);

    public SavedProjectModel getSavedProjectByFreelancerAndProject(int freelancerId, int projectId);

    public boolean isProjectSaved(int freelancerId, int projectId);

    public List<Integer> getSavedProjectIdsByFreelancer(int freelancerId);

    public List<SavedProjectModel> getSavedProjectsByFreelancer(int freelancerId, String search, String sort, int offset, int limit);

    public long countSavedProjectsByFreelancer(int freelancerId, String search);

    public long countSavedProjectsByFreelancer(int freelancerId);
}
