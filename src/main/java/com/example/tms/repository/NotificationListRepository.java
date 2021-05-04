package com.example.tms.repository;

import com.example.tms.entity.NotificationList;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NotificationListRepository extends MongoRepository<NotificationList, Long> {
}
