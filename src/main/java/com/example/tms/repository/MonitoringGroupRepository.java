package com.example.tms.repository;

import com.example.tms.entity.Log;
import com.example.tms.entity.MonitoringGroup;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Date;
import java.util.List;

public interface MonitoringGroupRepository extends MongoRepository<MonitoringGroup, Long> {
    MonitoringGroup findByGroupNum(int key);
    MonitoringGroup findByGroupName(String groupName);
    MonitoringGroup findByGroupMemberIsIn(String id);
    MonitoringGroup findTopByOrderByGroupNumDesc();
    List<MonitoringGroup> findByMonitoringPlaceIsIn(String place);
    List<MonitoringGroup> findBySensorIsIn(String sensor);
}
