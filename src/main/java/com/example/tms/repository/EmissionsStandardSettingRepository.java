package com.example.tms.repository;

import com.example.tms.entity.EmissionsSetting;
import com.example.tms.entity.EmissionsStandardSetting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;



public interface EmissionsStandardSettingRepository extends MongoRepository<EmissionsStandardSetting, ObjectId> {
    EmissionsStandardSetting findByTableNameIsIn(String tableName);
    EmissionsStandardSetting deleteByTableName(String tableName);
}
