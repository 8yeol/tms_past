package com.example.tms.repository;

import com.example.tms.entity.*;

import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Repository
@Log4j2
public class SensorCustomRepository {

    final MongoTemplate mongoTemplate;

    public SensorCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }


    /**
     * @param sensor (sensor sensor)
     * @param minute (60 - 1hour, 1440 - 24hour, ...)
     * @return List<Sensor> </sensor>_id, value, status, up_time
     */
    public List<Sensor> getSenor(String sensor, String minute){
        /* from A to B : A 부터 B까지 */
        LocalDateTime A = null;  LocalDateTime B = null;

            if (minute.isEmpty()){ //from, to, minute 미입력 : 24시간 전 ~ 현재
                A = LocalDateTime.now().minusMinutes(Long.parseLong("1440"));
                B = LocalDateTime.now();
            }else{ //from, to 미입력, minute 입력 :  현재(-minute) ~ 현재
                A = LocalDateTime.now().minusMinutes(Long.parseLong(minute));
                B = LocalDateTime.now();
            }

        try {
            if(A.isBefore(B)){
                //A.compare(B) - A<B:1,  A>B:1, A==B:0
                ProjectionOperation projectionOperation = Aggregation.project()
                        .andInclude("value")
                        .andInclude("status")
                        .andInclude("up_time");
                /* match - gt:>, gte:>=, lt:<, lte:<=, ne:!*/
//        MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("status").is(value)));
                MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("up_time")
                        .gte(A).lte(B)
                ));
                /* sort */
                SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");
                /* limit */
//        LimitOperation limitOperation = Aggregation.limit(1);
                /* fetch */
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

    /* String type -> LocalDateTime format  */
    private LocalDateTime format_time(String datetime, boolean end){
        try {
            LocalDateTime newDateTime = null;
            // length : 2021-04-22T01:33:00 - 19, 2021-04-22 01:33:00 - 19, 2021-04-22 - 10, 01:33:00 - 8, 2021-04 - 7, 01:33 - 5
            if(datetime.length() == 19){
                datetime = datetime.replace(" ", "T");
                newDateTime = LocalDateTime.parse(datetime);
            }else if(datetime.length() == 10 && !end){
                newDateTime = LocalDateTime.parse(datetime+"T00:00:00");
            }else if(datetime.length() == 10 && end){
                newDateTime = LocalDateTime.parse(datetime+"T23:59:59");
            }else if(datetime.length() == 8 || datetime.length() == 5){
                newDateTime = LocalDateTime.parse(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"T"+datetime);
            }else if(datetime.length() == 7){
                newDateTime = LocalDateTime.parse(datetime+"-01T00:00:00");
            }else{
                newDateTime = LocalDateTime.now();
            }
            return newDateTime; /* Year-Month-Day + T + Hours:Minutes:Seconds */
        }catch (Exception e){
            log.info(e.getMessage());

        }
        return null;
    }

    /* 최근 데이터 조회 */
    public Sensor getSensorRecent(String sensor){
        try{
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("value")
                    .andInclude("status")
                    .andInclude("up_time");
            /* sort */
            SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");
            /* limit */
            LimitOperation limitOperation = Aggregation.limit(1);
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation, sortOperation, limitOperation);

            AggregationResults<Sensor> results = mongoTemplate.aggregate(aggregation, sensor, Sensor.class);
            List<Sensor> result = results.getMappedResults();
            return result.get(0); //-> Json -> sensor 타입으로 변경 필요
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

    /* 최근데이터 2개 조회 후 2번째 데이터 리턴 */
    public Sensor getSensorBeforeData(String sensor){
        try{
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("value")
                    .andInclude("status")
                    .andInclude("up_time");
            /* sort */
            SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");
            /* limit */
            LimitOperation limitOperation = Aggregation.limit(2);
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation, sortOperation, limitOperation);

            AggregationResults<Sensor> results = mongoTemplate.aggregate(aggregation, sensor, Sensor.class);
            List<Sensor> result = results.getMappedResults();
            return result.get(1);
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

}
