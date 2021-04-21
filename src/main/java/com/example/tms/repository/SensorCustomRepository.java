package com.example.tms.repository;

import com.example.tms.entity.Sensor;
import com.example.tms.entity.Sensor_Info;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Repository
public class SensorCustomRepository {


    final MongoTemplate mongoTemplate;

    public SensorCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }



// =====================================================================================================================
// 현재시간-time ~ 현재시간에 해당하는 센서 조회
// param # key :  String name (sensor_name) int time (현재시간-time)
// return # Sensor(value, status, up_time(desc))
// =====================================================================================================================
    public List<Sensor> getSenor(String name, String start_date, String end_date){
        if(start_date == null && end_date == null){

        }
        ProjectionOperation projectionOperation = Aggregation.project()
                .andInclude("value")
                .andInclude("status")
                .andInclude("up_time");
        /* match - gt:>, gte:>=, lt:<, lte:<=, ne:!*/
//        MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("status").is(value)));
        MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("up_time")
                .gte(LocalDateTime.now().minusHours(10)).lte(LocalDateTime.now())
        ));
        /* sort */
        SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");
        /* limit */
//        LimitOperation limitOperation = Aggregation.limit(1);
        /* fetch */
        Aggregation aggregation = Aggregation.newAggregation(projectionOperation, matchOperation, sortOperation);

        AggregationResults<Sensor> results = mongoTemplate.aggregate(aggregation, name, Sensor.class);
        List<Sensor> result = results.getMappedResults();
        return result;
    }
}
