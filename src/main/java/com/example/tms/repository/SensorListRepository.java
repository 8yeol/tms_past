package com.example.tms.repository;

import com.example.tms.entity.ReferenceValueSetting;
import com.example.tms.entity.SensorList;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface SensorListRepository extends MongoRepository<ReferenceValueSetting, ObjectId> {

}
