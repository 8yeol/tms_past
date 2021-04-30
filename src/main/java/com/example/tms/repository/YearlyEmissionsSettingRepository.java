package com.example.tms.repository;

import com.example.tms.entity.YearlyEmissionsSetting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;


public interface YearlyEmissionsSettingRepository extends MongoRepository<YearlyEmissionsSetting, ObjectId> {
    YearlyEmissionsSetting findBySensor(String sensor);
}
