package com.example.tms.repository;

import com.example.tms.entity.Notification_Settings;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface Notification_SettingsRepository extends MongoRepository<Notification_Settings, ObjectId> {
    Notification_Settings findByName(String name);
    List<Notification_Settings> findByStatusIsTrue();
}
