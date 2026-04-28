package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.SavedProjectDao;
import com.model.SavedProjectModel;

@Service
@Transactional
public class SavedProjectServiceImpl implements SavedProjectService {

    @Autowired
    private SavedProjectDao savedProjectDao;

    @Override
    public void saveSavedProject(SavedProjectModel savedProject) {
        savedProjectDao.saveSavedProject(savedProject);
    }

    @Override
    public void deleteSavedProject(SavedProjectModel savedProject) {
        savedProjectDao.deleteSavedProject(savedProject);
    }

    @Override
    public SavedProjectModel getSavedProjectById(int savedProjectId) {
        return savedProjectDao.getSavedProjectById(savedProjectId);
    }

    @Override
    public SavedProjectModel getSavedProjectByFreelancerAndProject(int freelancerId, int projectId) {
        return savedProjectDao.getSavedProjectByFreelancerAndProject(freelancerId, projectId);
    }

    @Override
    public boolean isProjectSaved(int freelancerId, int projectId) {
        return savedProjectDao.isProjectSaved(freelancerId, projectId);
    }

    @Override
    public List<Integer> getSavedProjectIdsByFreelancer(int freelancerId) {
        return savedProjectDao.getSavedProjectIdsByFreelancer(freelancerId);
    }

    @Override
    public List<SavedProjectModel> getSavedProjectsByFreelancer(int freelancerId, String search, String sort, int offset, int limit) {
        return savedProjectDao.getSavedProjectsByFreelancer(freelancerId, search, sort, offset, limit);
    }

    @Override
    public long countSavedProjectsByFreelancer(int freelancerId, String search) {
        return savedProjectDao.countSavedProjectsByFreelancer(freelancerId, search);
    }

    @Override
    public long countSavedProjectsByFreelancer(int freelancerId) {
        return savedProjectDao.countSavedProjectsByFreelancer(freelancerId);
    }
}
