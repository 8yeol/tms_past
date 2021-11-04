package com.example.tms.repository;

import com.example.tms.entity.MonthlyEmissions;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface MonthlyEmissionsRepository extends MongoRepository<MonthlyEmissions, Long> {
    MonthlyEmissions findBySensorAndYear(String sensor, int year);
    MonthlyEmissions deleteBySensor(String sensor);
    List<MonthlyEmissions> findBySensor(String sensor);
    MonthlyEmissions findByYear(int year);
}
