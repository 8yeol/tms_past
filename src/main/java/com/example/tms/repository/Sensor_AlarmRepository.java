package com.example.tms.repository;


import com.example.tms.entity.Sensor_Alarm;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Sensor_AlarmRepository extends MongoRepository<Sensor_Alarm, String> {
    Sensor_Alarm findByName(String name);
}
