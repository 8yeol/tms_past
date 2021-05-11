package com.example.tms.repository;

import com.example.tms.entity.SensorList;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.bson.types.ObjectId;

import java.util.List;

public interface SensorListRepository extends MongoRepository<SensorList, ObjectId> {
    List<SensorList> findByPlace(String place);
    String findByTableName(String tableName);
    SensorList findByTableName(String tableName,String Null);  //오버로딩 위해 필요없는 인자 Null 받습니다.

}
