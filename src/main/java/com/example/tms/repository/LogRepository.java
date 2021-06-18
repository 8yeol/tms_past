package com.example.tms.repository;

import com.example.tms.entity.Log;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Date;
import java.util.List;

public interface LogRepository extends MongoRepository<Log, Long> {
    long countById(String id);
    long countByIdAndContentLike(String id,String content);
    long countByIdAndType(String id,String type);
    long countByIdAndDate(String id, Date date);
    List<Log> findById(String id);
    void deleteById(String id);
}
