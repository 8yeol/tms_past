package com.example.tms.repository;

import com.example.tms.entity.Log;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface LogRepository extends MongoRepository<Log, Long> {
    long countById(String id);
//    long countByContentIsIn(String searchKey);
    long countByIdAndContentLike(String id,String content);
    List<Log> findById(String id);
    void deleteById(String id);
}
