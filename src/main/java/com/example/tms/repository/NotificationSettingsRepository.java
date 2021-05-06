package com.example.tms.repository;

import com.example.tms.entity.NotificationSettings;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface NotificationSettingsRepository extends MongoRepository<NotificationSettings, ObjectId> {
    NotificationSettings findByName(String name);
    List<NotificationSettings> findByStatusIsTrue();
}
