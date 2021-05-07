package com.example.tms.repository;

import com.example.tms.entity.SensorList;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.bson.types.ObjectId;

import java.util.List;

public interface SensorListRepository extends MongoRepository<SensorList, ObjectId> {
    List<SensorList> findByPlace(String place);
    String findByTableName(String tableName);

}
