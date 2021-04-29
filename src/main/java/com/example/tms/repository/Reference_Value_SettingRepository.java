package com.example.tms.repository;

import com.example.tms.entity.Reference_Value_Setting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface Reference_Value_SettingRepository extends MongoRepository<Reference_Value_Setting, ObjectId> {
    Reference_Value_Setting findByName(String name);
    Reference_Value_Setting findByNameAndPower(String name, String power);
}
