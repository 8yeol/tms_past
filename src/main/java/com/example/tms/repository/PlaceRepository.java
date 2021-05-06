package com.example.tms.repository;


import com.example.tms.entity.Place;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface PlaceRepository extends MongoRepository<Place, Long> {
    Place findByName(String name);
    //해당 센서 값이 포함된 측정소 찾기
    Place findBySensorIsIn(String sensorName);

    void deleteByName(String name);

    List<Place> findByMonitoringIsTrue();
}
