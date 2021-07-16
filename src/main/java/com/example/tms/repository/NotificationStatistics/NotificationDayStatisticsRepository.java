package com.example.tms.repository.NotificationStatistics;

import com.example.tms.entity.NotificationDayStatistics;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NotificationDayStatisticsRepository extends MongoRepository<NotificationDayStatistics, ObjectId> {
    NotificationDayStatistics findByDayAndPlace(String day, String place);
}
