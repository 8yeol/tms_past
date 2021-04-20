package com.example.tms.repository;

import com.example.tms.entity.Place;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PlaceMongoRepository extends MongoRepository<Place, String> {
    Place findBy_id(String id);
}
