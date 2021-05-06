package com.example.tms.repository;

import com.example.tms.entity.NotificationList;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;

@Repository
@Log4j2
public class NotificationListCustomRepository {

    final MongoTemplate mongoTemplate;

    public NotificationListCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public List<HashMap> getCount(int grade, LocalDateTime from_date, LocalDateTime to_date){
        try{
            if(from_date.isBefore(to_date)){
                ProjectionOperation projectionOperation = Aggregation.project()
                        .andInclude("grade")
                        .andInclude("up_time")
                        .andInclude("count");
                MatchOperation matchOperation = Aggregation.match(new Criteria()
                            .andOperator(Criteria.where("up_time").gte(from_date).lte(to_date)
                                    .andOperator(Criteria.where("grade").is(grade)
                                    )));

                SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");

                GroupOperation groupOperation = Aggregation
                        .group("grade"/*, "sensor", "grade", "notify"*/).count().as("count");
                Aggregation aggregation = Aggregation.newAggregation(projectionOperation, matchOperation, sortOperation, groupOperation);

                AggregationResults<HashMap> results = mongoTemplate.aggregate(aggregation, "notification_list", HashMap.class);
                List<HashMap> result = results.getMappedResults();
                return result;
            }
        }catch (Exception e){
            log.info(e.getMessage());
        }
        return null;
    }

   /* public List<HashMap> getCount(String place, String sensor, String grade, String from_date, String to_date, String minute){
        *//* from A to B : A 부터 B까지 *//*
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
                A = format_time(from_date, false);
                B = format_time(to_date, true);
            }else{ // from, to 둘 중 하나만 입력
                if(!minute.isEmpty()){ // minute 입력
                    if(!to_date.isEmpty()){ // to 입력, from(-minute) ~ to
                        A = format_time(to_date, false).minusMinutes(Long.parseLong(minute));
                        B = format_time(to_date, true);
                    }else if(!from_date.isEmpty()){ //from 입력, from ~ to(+minute)
                        A = format_time(from_date, false);
                        B = format_time(from_date, true).plusMinutes(Long.parseLong(minute));
                    }
                }else{ // minute 미입력
                    if(!to_date.isEmpty()){ // 하루전 ~ 현재
                        A = format_time(to_date, false).minusDays(1);
                        B = format_time(to_date, true);
                    }else if(!from_date.isEmpty()){ // from ~ 현재
                        A = format_time(from_date, false);
                        B = LocalDateTime.now();
                    }
                }
            }
        }
        try{
            if(A.isBefore(B)){
                ProjectionOperation projectionOperation = Aggregation.project()
                        .and("place").as("place")
                        .and("sensor").as("sensor")
                        .andInclude("value")
                        .andInclude("grade")
                        .andInclude("notify")
                        .andInclude("up_time")
                        .andInclude("count");
                MatchOperation matchOperation = null;
                if(!sensor.isEmpty() && !grade.isEmpty()) {
                    matchOperation = Aggregation.match(new Criteria()
                        .andOperator(Criteria.where("up_time").gte(A).lte(B)
                        .andOperator(Criteria.where("place").is(place)
                        .andOperator(Criteria.where("sensor").is(sensor)
                        .andOperator(Criteria.where("grade").is(Integer.valueOf(grade)))
                        )
                        )));
                }else if(!sensor.isEmpty() && grade.isEmpty()){
                    matchOperation = Aggregation.match(new Criteria()
                        .andOperator(Criteria.where("up_time").gte(A).lte(B)
                        .andOperator(Criteria.where("place").is(place)
                        .andOperator(Criteria.where("sensor").is(sensor))
                        )));
                }else if(sensor.isEmpty() && !grade.isEmpty()){
                    matchOperation = Aggregation.match(new Criteria()
                        .andOperator(Criteria.where("up_time").gte(A).lte(B)
                        .andOperator(Criteria.where("place").is(place)
                        .andOperator(Criteria.where("grade").is(Integer.valueOf(grade)))
                    )));
                }else{
                    matchOperation = Aggregation.match(new Criteria()
                        .andOperator(Criteria.where("up_time").gte(A).lte(B)
                        .andOperator(Criteria.where("place").is(place)
                        )));
                }
//                        ));
                SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");

                GroupOperation groupOperation = Aggregation
                        .group("place"*//*, "sensor", "grade", "notify"*//*).count().as("count");
                Aggregation aggregation = Aggregation.newAggregation(projectionOperation, matchOperation, sortOperation, groupOperation);

                AggregationResults<HashMap> results = mongoTemplate.aggregate(aggregation, "notification_list", HashMap.class);
                List<HashMap> result = results.getMappedResults();
                return result;
            }
        }catch (Exception e){
            log.info(e.getMessage());
        }
        return null;
    }*/

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
}
