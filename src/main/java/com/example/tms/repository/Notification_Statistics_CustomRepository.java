package com.example.tms.repository;

import lombok.extern.log4j.Log4j2;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Repository;

@Repository
@Log4j2
public class Notification_Statistics_CustomRepository {

    final MongoTemplate mongoTemplate;

    public Notification_Statistics_CustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }
}
