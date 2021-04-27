package com.example.tms.repository;


import com.example.tms.entity.Place;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface PlaceRepository extends MongoRepository<Place, Long> {
    Place findByName(String name);

}
