package com.example.tms.repository;

import com.example.tms.entity.Place;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface PlaceRepository extends MongoRepository<Place, Long> {
    Place findByName(String name);
    Place findBySensorIsIn(String sensor);
    void deleteByName(String name);
    List<Place> findByMonitoringIsTrue();
}
