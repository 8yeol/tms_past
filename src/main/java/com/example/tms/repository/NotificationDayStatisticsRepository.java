package com.example.tms.repository;

import com.example.tms.entity.NotificationDayStatistics;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NotificationDayStatisticsRepository extends MongoRepository<NotificationDayStatistics, ObjectId> {
//save 사용
    NotificationDayStatistics deleteByDay(String day);
}
