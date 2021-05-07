package com.example.tms.repository;

import com.example.tms.entity.SensorList;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface SensorListRepository extends MongoRepository<SensorList, Object> {

}
