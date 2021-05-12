package com.example.tms.repository;

import com.example.tms.entity.Item;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ItemRepository extends MongoRepository<Item, Object> {
    Item findByClassification(String classification);
}
