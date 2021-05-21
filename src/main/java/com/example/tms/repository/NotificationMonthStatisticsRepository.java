package com.example.tms.repository;

import com.example.tms.entity.NotificationMonthStatistics;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NotificationMonthStatisticsRepository extends MongoRepository<NotificationMonthStatistics, ObjectId> {
    NotificationMonthStatistics deleteByMonth(String month);
}
