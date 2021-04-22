package com.example.tms.repository;

import com.example.tms.entity.Sensor_Info;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface Sensor_InfoRepository extends MongoRepository<Sensor_Info, String> {
    Sensor_Info findByName(String name);

}
