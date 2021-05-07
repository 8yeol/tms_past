package com.example.tms.repository.MonthlyEmissions;

import com.example.tms.entity.MonthlyEmissions;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface MonthlyEmissionsRepository extends MongoRepository<MonthlyEmissions, Long> {
    MonthlyEmissions findBySensorAndYear(String sensor, int year);
}
