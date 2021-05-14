package com.example.tms.repository;

import com.example.tms.entity.EmissionsSetting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;


public interface EmissionsSettingRepository extends MongoRepository<EmissionsSetting, ObjectId> {
    EmissionsSetting findBySensor(String sensor);
    void deleteBySensor(String sensor);

    List<EmissionsSetting> findByStatus(boolean bool);
}
