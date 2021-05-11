package com.example.tms.repository;

import com.example.tms.entity.Item;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;



public interface ItemRepository extends MongoRepository<Item, ObjectId> {
    Item findBySensorCode(String sensorCode);
}
