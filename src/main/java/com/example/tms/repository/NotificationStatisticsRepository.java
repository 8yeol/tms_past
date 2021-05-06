package com.example.tms.repository;

import com.example.tms.entity.NotificationStatistics;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface NotificationStatisticsRepository extends MongoRepository<NotificationStatistics, ObjectId> {

    List<NotificationStatistics> findByPlace(String place);

}
