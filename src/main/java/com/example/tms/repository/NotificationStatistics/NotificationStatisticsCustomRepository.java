package com.example.tms.repository.NotificationStatistics;

import com.example.tms.entity.NotificationMonthStatistics;
import com.example.tms.entity.NotificationDayStatistics;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Log4j2
public class NotificationStatisticsCustomRepository {

    final MongoTemplate mongoTemplate;

    public NotificationStatisticsCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * 최근 일주일 알림 현황(기준 초과 카운팅) 리턴
     * @return ["yyyy-mm-dd, 법적기준초과, 사내기준초과, 관리기준초과", ...]
     */
    public List<NotificationDayStatistics> getNotificationWeekStatistics(String place){
        try{
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("place")
                    .andInclude("day")
                    .andInclude("legalCount")
                    .andInclude("companyCount")
                    .andInclude("managementCount");
            MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("place").is(place)));
            /* sort */
            SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "day");
            /* limit */
            LimitOperation limitOperation = Aggregation.limit(7);
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation, matchOperation, sortOperation, limitOperation);

            AggregationResults<NotificationDayStatistics> results = mongoTemplate.aggregate(aggregation, "notification_day_statistics", NotificationDayStatistics.class);
            List<NotificationDayStatistics> result = results.getMappedResults();
            return result;
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

    /**
     * 최근 1년 알림 현황(기준 초과 카운팅) 리턴
     * @return ["yyyy-mm, 법적기준초과, 사내기준초과, 관리기준초과", ...]
     */
    public List<NotificationMonthStatistics> getNotificationMonthStatistics(String place){

        try{
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("place")
                    .andInclude("month")
                    .andInclude("legalCount")
                    .andInclude("companyCount")
                    .andInclude("managementCount");
            MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("place").is(place)));
            /* sort */
            SortOperation sortOperation = Aggregation.sort(Sort.Direction.DESC, "month");
            /* limit */
            LimitOperation limitOperation = Aggregation.limit(12);
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation, matchOperation, sortOperation, limitOperation);

            AggregationResults<NotificationMonthStatistics> results = mongoTemplate.aggregate(aggregation, "notification_month_statistics", NotificationMonthStatistics.class);
            List<NotificationMonthStatistics> result = results.getMappedResults();
            return result;
        }catch (Exception e){
            log.info("getSensorRecent error" + e.getMessage());
        }
        return null;
    }

}
