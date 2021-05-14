package com.example.tms.repository;

import com.example.tms.entity.AnnualEmissions;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;


public interface AnnualEmissionsRepository extends MongoRepository<AnnualEmissions, ObjectId> {
    AnnualEmissions findBySensor(String sensor);
    List<AnnualEmissions> findByStatusIsTrue();
    void deleteBySensor(String sensor);
    List findByPlace(String place);
}
