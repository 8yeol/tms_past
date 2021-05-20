package com.example.tms.repository;

import com.example.tms.entity.EmissionsTransition;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface EmissionsTransitionRepository extends MongoRepository<EmissionsTransition, ObjectId> {
    EmissionsTransition findByTableNameAndYearEquals(String tableName, int year);
    List findByPlaceName(String placeName);
    EmissionsTransition findByTableName(String tableName);
    void deleteByTableName(String tableName);
}
