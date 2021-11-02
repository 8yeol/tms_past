package com.example.tms.repository.NotificationList;

import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

@Repository
@Log4j2
public class NotificationListCustomRepository {

    final MongoTemplate mongoTemplate;

    public NotificationListCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /** 기준별 초과 카운팅
     * @param grade  기준 초과 등급 1~3(1 법적,2 사내)
     * @param from_date
     * @param to_date
     * @return int 기준별, 날짜별 카운팅된 숫자
     */
    public List<HashMap> getCount(int grade, String from_date, String to_date, String place){
        LocalDateTime fromDate = LocalDateTime.parse(from_date + "T00:00:00");
        LocalDateTime toDate = LocalDateTime.parse(to_date + "T23:59:59");
        try{
            if(fromDate.isBefore(toDate)){
                ProjectionOperation projectionOperation = Aggregation.project()
                        .andInclude("place")
                        .andInclude("grade")
                        .andInclude("up_time")
                        .andInclude("count");
                MatchOperation matchOperation = Aggregation.match(new Criteria()
                            .andOperator(Criteria.where("up_time").gte(fromDate).lte(toDate)
                                    .andOperator(Criteria.where("grade").is(grade)
                                            .andOperator(Criteria.where("place").is(place)
                                    )
                            )));

                SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "up_time");

                GroupOperation groupOperation = Aggregation
                        .group("grade").count().as("count");
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
}
