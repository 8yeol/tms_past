package com.example.tms.repository;

import com.example.tms.entity.Log;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface LogRepository extends MongoRepository<Log, Long> {
    List<Log> findById(String id);
    void deleteById(String id);
}
