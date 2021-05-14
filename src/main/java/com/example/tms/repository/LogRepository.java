package com.example.tms.repository;


import com.example.tms.entity.Log;
import org.springframework.data.mongodb.repository.MongoRepository;


public interface LogRepository extends MongoRepository<Log, Long> {

}
