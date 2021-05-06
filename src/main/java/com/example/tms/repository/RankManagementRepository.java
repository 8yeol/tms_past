package com.example.tms.repository;


import com.example.tms.entity.RankManagement;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RankManagementRepository extends MongoRepository<RankManagement, Long> {
    RankManagement findByName(String str);
}
