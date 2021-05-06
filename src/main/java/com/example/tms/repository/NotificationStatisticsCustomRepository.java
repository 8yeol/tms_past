package com.example.tms.repository;

import com.example.tms.entity.NotificationMonthStatistics;
import com.example.tms.entity.NotificationDayStatistics;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Log4j2
public class NotificationStatisticsCustomRepository {

    final MongoTemplate mongoTemplate;

    public NotificationStatisticsCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }


    /* 최근 일주일 조회 (일 데이터 )*/
    public List<NotificationDayStatistics> getNotificationWeekStatistics(){
        try{
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("day")
                    .andInclude("legalCount")
                    .andInclude("companyCount")
                    .andInclude("managementCount");
            /* sort */
            SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "day");
            /* limit */
            LimitOperation limitOperation = Aggregation.limit(7);
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation, sortOperation, limitOperation);

            AggregationResults<NotificationDayStatistics> results = mongoTemplate.aggregate(aggregation, "notification_day_statistics", NotificationDayStatistics.class);
            List<NotificationDayStatistics> result = results.getMappedResults();
            return result; //-> Json -> sensor 타입으로 변경 필요
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

    /* 최근 1년 조회 (월 데이터 )*/
    public List<NotificationMonthStatistics> getNotificationMonthStatistics(){

        try{
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("month")
                    .andInclude("legalCount")
                    .andInclude("companyCount")
                    .andInclude("managementCount");
            /* sort */
            SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "month");
            /* limit */
            LimitOperation limitOperation = Aggregation.limit(12);
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation, sortOperation, limitOperation);

            AggregationResults<NotificationMonthStatistics> results = mongoTemplate.aggregate(aggregation, "notification_month_statistics", NotificationMonthStatistics.class);
            List<NotificationMonthStatistics> result = results.getMappedResults();
            return result; //-> Json -> sensor 타입으로 변경 필요
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

}
