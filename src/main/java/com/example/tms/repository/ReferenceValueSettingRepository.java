package com.example.tms.repository;

import com.example.tms.entity.ReferenceValueSetting;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ReferenceValueSettingRepository extends MongoRepository<ReferenceValueSetting, ObjectId> {
    ReferenceValueSetting findByName(String name);
    List<ReferenceValueSetting> findByMonitoringIsTrue();

    void deleteByName(String name);//삭제
}
