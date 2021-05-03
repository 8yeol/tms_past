package com.example.tms.repository;


import com.example.tms.entity.rank_management;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface Rank_ManagementRepository extends MongoRepository<rank_management, Long> {
    rank_management findByName(String str);
}
