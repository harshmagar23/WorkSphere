package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.BidDao;
import com.model.BidModel;

@Service
@Transactional
public class BidServiceImpl implements BidService {

    @Autowired
    private BidDao bidDao;

    @Override
    public void saveBid(BidModel bid) {
        bidDao.saveBid(bid);
    }

    @Override
    public List<BidModel> getBidsByFreelancerId(int freelancerId) {
        return bidDao.getBidsByFreelancerId(freelancerId);
    }

    @Override
    public List<BidModel> getBidsByProjectId(int projectId) {
        return bidDao.getBidsByProjectId(projectId);
    }

    @Override
    public BidModel getBidById(int bidId) {
        return bidDao.getBidById(bidId);
    }

    @Override
    public void updateBid(BidModel bid) {
        bidDao.updateBid(bid);
    }

    @Override
    public BidModel getBidByProjectAndFreelancer(int projectId, int freelancerId) {
        return bidDao.getBidByProjectAndFreelancer(projectId, freelancerId);
    }

    @Override
    public long countBidsByFreelancer(int freelancerId) {
        return bidDao.countBidsByFreelancer(freelancerId);
    }

    @Override
    public long countAcceptedBidsByFreelancer(int freelancerId) {
        return bidDao.countAcceptedBidsByFreelancer(freelancerId);
    }

    @Override
    public long countBidsByClientProjects(int clientId) {
        return bidDao.countBidsByClientProjects(clientId);
    }

    @Override
    public List<BidModel> searchBidsByFreelancer(int freelancerId,
                                                 String keyword,
                                                 String status,
                                                 String sort,
                                                 int page,
                                                 int size) {
        return bidDao.searchBidsByFreelancer(freelancerId, keyword, status, sort, page, size);
    }

    @Override
    public long countSearchBidsByFreelancer(int freelancerId,
                                            String keyword,
                                            String status) {
        return bidDao.countSearchBidsByFreelancer(freelancerId, keyword, status);
    }

    @Override
    public long countBidsByFreelancerAndStatus(int freelancerId, String status) {
        return bidDao.countBidsByFreelancerAndStatus(freelancerId, status);
    }
}
