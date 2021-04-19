package com.example.tms.repository;

import com.example.tms.entity.*;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.repository.support.QuerydslRepositorySupport;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Log4j2
public class SensorQueryDslRepository extends QuerydslRepositorySupport {

    public SensorQueryDslRepository(MongoOperations operations) {
        super(operations);
    }

    QSensor qSensor = QSensor.sensor;

// =====================================================================================================================
// param # key : String sensor_name (Place.sensor)
// return # Sensor(value, status, up_time(desc)) List (select * from #Place.sensor order by up_time desc)
// =====================================================================================================================
    public List<Sensor> getSensor(String sensor_name){
        List<Sensor> list = from(qSensor, sensor_name).where().orderBy(qSensor.up_time.desc()).fetch();
        return list;
    }

// =====================================================================================================================
// param # key : String sensor_name (Place.sensor), String limit_amount
// return # Sensor(value, status, up_time(desc)) List (select * from #Place.sensor order by up_time desc limit #limit_amount)
// =====================================================================================================================
    public List<Sensor> getSensor(String sensor_name, String limit_amount){
        List<Sensor> list = from(qSensor, sensor_name).where().limit(Long.parseLong(limit_amount)).orderBy(qSensor.up_time.desc()).fetch();
        return list;
    }
}
