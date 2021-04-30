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
     * @param from_date,to_date ('', 'Year-Month-Day hh:mm:ss', 'Year-Month-Day', 'hh:mm:ss', 'hh:mm')
     * @param minute (60 - 1hour, 1440 - 24hour, ...)
     * @return List<Sensor> </sensor>_id, value, status, up_time
     */
    public List<Sensor> getSenor(String sensor, String from_date, String to_date, String minute){
        /* from A to B : A 부터 B까지 */
        LocalDateTime A = null;  LocalDateTime B = null;
        if(from_date.isEmpty() && to_date.isEmpty()){
            if (minute.isEmpty()){ //from, to, minute 미입력 : 24시간 전 ~ 현재
                A = LocalDateTime.now().minusMinutes(Long.parseLong("1440"));
                B = LocalDateTime.now();
            }else{ //from, to 미입력, minute 입력 :  현재(-minute) ~ 현재
                A = LocalDateTime.now().minusMinutes(Long.parseLong(minute));
                B = LocalDateTime.now();
            }
        }else{ // from, to 입력
            if(!from_date.isEmpty() && !to_date.isEmpty()){ // from ~ to
                A = format_time(from_date);
                B = format_time(to_date);
            }else{ // from, to 둘 중 하나만 입력
                if(!minute.isEmpty()){ // minute 입력
                    if(!to_date.isEmpty()){ // to 입력, from(-minute) ~ to
                        A = format_time(to_date).minusMinutes(Long.parseLong(minute));
                        B = format_time(to_date);
                    }else if(!from_date.isEmpty()){ //from 입력, from ~ to(+minute)
                        A = format_time(from_date);
                        B = format_time(from_date).plusMinutes(Long.parseLong(minute));
                    }
                }else{ // minute 미입력
                    if(!to_date.isEmpty()){ // 하루전 ~ 현재
                        A = format_time(to_date).minusDays(1);
                        B = format_time(to_date);
                    }else if(!from_date.isEmpty()){ // from ~ 현재
                        A = format_time(from_date);
                        B = LocalDateTime.now();
                    }
                }
            }
        }

        try {
            if(A.compareTo(B) == -1){ //from < to
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
    private LocalDateTime format_time(String datetime){
        LocalDateTime newDateTime = null;
        // length : 2021-04-22T01:33:00 - 19, 2021-04-22 01:33:00 - 19, 2021-04-22 - 10, 01:33:00 - 8, 01:33 - 5
        if(datetime.length() == 19){
            datetime = datetime.replace(" ", "T");
            newDateTime = LocalDateTime.parse(datetime);
        }else if(datetime.length() == 10){
            newDateTime = LocalDateTime.parse(datetime+"T00:00:00");
        }else if(datetime.length() == 8 || datetime.length() == 5){
            newDateTime = LocalDateTime.parse(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"T"+datetime);
        }else{
            newDateTime = LocalDateTime.now();
        }
        return newDateTime; /* Year-Month-Day + T + Hours:Minutes:Seconds */
    }

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


}
