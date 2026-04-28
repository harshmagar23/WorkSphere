package com.service;

import java.util.List;
import com.model.BidModel;

public interface BidService {

    public void saveBid(BidModel bid);

    public List<BidModel> getBidsByFreelancerId(int freelancerId);

    public List<BidModel> getBidsByProjectId(int projectId);

    public BidModel getBidById(int bidId);

    public void updateBid(BidModel bid);

    public BidModel getBidByProjectAndFreelancer(int projectId, int freelancerId);

    public long countBidsByFreelancer(int freelancerId);

    public long countAcceptedBidsByFreelancer(int freelancerId);

    public long countBidsByClientProjects(int clientId);

    public List<BidModel> searchBidsByFreelancer(int freelancerId,
                                                 String keyword,
                                                 String status,
                                                 String sort,
                                                 int page,
                                                 int size);

    public long countSearchBidsByFreelancer(int freelancerId,
                                            String keyword,
                                            String status);

    public long countBidsByFreelancerAndStatus(int freelancerId, String status);
}
