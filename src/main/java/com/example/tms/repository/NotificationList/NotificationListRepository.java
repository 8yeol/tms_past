package com.example.tms.repository.NotificationList;

import com.example.tms.entity.NotificationList;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Date;
import java.util.List;

public interface NotificationListRepository extends MongoRepository<NotificationList, Long> {
    List<NotificationList> findBySensor(String sensor);
    List<NotificationList> findByNameAndCheck(String name, String check);
    List<NotificationList> findByCheck(String check);

}
