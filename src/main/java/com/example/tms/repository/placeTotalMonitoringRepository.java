package com.example.tms.repository;

import com.example.tms.entity.placeTotalMonitoring;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface placeTotalMonitoringRepository extends MongoRepository<placeTotalMonitoring, ObjectId> {
    List<placeTotalMonitoring> findByTableNameOrderByYearDesc(String tableName);
}
