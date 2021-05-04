package com.example.tms.repository;

import com.example.tms.entity.Notification_Statistics;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface Notification_StatisticsRepository extends MongoRepository<Notification_Statistics, ObjectId> {

}
