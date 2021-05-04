package com.example.tms.repository;

import com.example.tms.entity.YearlyEmissions;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;


public interface YearlyEmissionsRepository extends MongoRepository<YearlyEmissions, ObjectId> {

}
