package com.example.tms.repository.Sensor;

import com.example.tms.entity.*;

import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
@Log4j2
public class SensorCustomRepository {

    final MongoTemplate mongoTemplate;

    public SensorCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**해당 센서의 현재-hour ~ 현재까지 데이터 리턴
     * @param sensor 센서명
     * @param hour 시간
     * @return List<Sensor>
     */
    public List<Sensor> getSenor(String sensor, String hour){
        /* from A to B : A 부터 B까지 */
        LocalDateTime A = null;  LocalDateTime B = null;

            if (hour.isEmpty()){ //from, to, minute 미입력 : 24시간 전 ~ 현재
                A = LocalDateTime.now().minusHours(Long.parseLong("24"));
                B = LocalDateTime.now();
            }else{ //from, to 미입력, minute 입력 :  현재(-minute) ~ 현재
                A = LocalDateTime.now().minusHours(Long.parseLong(hour));
                B = LocalDateTime.now();
            }

        try {
            if(A.isBefore(B)){
                ProjectionOperation projectionOperation = Aggregation.project()
                        .andInclude("value")
                        .andInclude("status")
                        .andInclude("up_time");
                MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("up_time")
                        .gte(A).lte(B)
                ));
                SortOperation sortOperation = Aggregation.sort(Sort.Direction.ASC, "up_time");
                Aggregation aggregation = Aggregation.newAggregation(projectionOperation, matchOperation, sortOperation);

                AggregationResults<Sensor> results = mongoTemplate.aggregate(aggregation, sensor, Sensor.class);
                List<Sensor> result = results.getMappedResults();
                return result;
            }
        }catch (Exception e){
            log.info(e.getMessage());
        }
        return null;
    }

    /**
     * 최근 센서 데이터 리턴
     * @param sensor 센서명
     * @return Sensor
     */
    public Sensor getSensorRecent(String sensor){
        try{
            Query query = new Query();
            query.with(Sort.by(Sort.Direction.DESC,"_id"));
            return mongoTemplate.findOne(query , Sensor.class, sensor);
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

    /**
     * 최근데이터의 직전값 리턴
     * @param sensor 센서명
     * @return Sensor
     */
    public Sensor getSensorBeforeData(String sensor){
        try{
            long count = mongoTemplate.estimatedCount(sensor);
            Query query = new Query();
            query.skip(count - 1);
            return mongoTemplate.findOne(query, Sensor.class, sensor);
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

}
