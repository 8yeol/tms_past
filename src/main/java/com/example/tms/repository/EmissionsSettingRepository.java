package com.example.tms.repository;

import com.example.tms.entity.EmissionsSetting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;


public interface EmissionsSettingRepository extends MongoRepository<EmissionsSetting, ObjectId> {
    EmissionsSetting findBySensor(String sensor);
}
