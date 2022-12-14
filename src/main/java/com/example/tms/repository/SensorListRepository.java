package com.example.tms.repository;

import com.example.tms.entity.SensorList;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.bson.types.ObjectId;

import java.util.List;

public interface SensorListRepository extends MongoRepository<SensorList, ObjectId> {
    List<SensorList> findByPlace(String place);
    SensorList findByTableName(String tableName);
    SensorList findByTableName(String tableName,String Null);
    void deleteByTableName(String tableName);
    List<SensorList> findByClassification(String classification);
    SensorList findByPlaceAndNaming(String place, String naming);

    List<SensorList> findByPlaceAndClassification(String place, String classification);
}
