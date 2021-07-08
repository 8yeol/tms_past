package com.example.tms.repository;

import com.example.tms.entity.Log;
import com.example.tms.entity.MonitoringGroup;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Date;
import java.util.List;

public interface MonitoringGroupRepository extends MongoRepository<MonitoringGroup, Long> {
}
