package com.example.tms.repository;

import com.example.tms.entity.YearlyEmissionsStandardSetting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;



public interface YearlyEmissionsStandardRepository extends MongoRepository<YearlyEmissionsStandardSetting, ObjectId> {
    YearlyEmissionsStandardSetting findBySensorCode(String sensorCode);
}
