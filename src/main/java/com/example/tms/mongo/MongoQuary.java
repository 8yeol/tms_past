package com.example.tms.mongo;

import com.example.tms.entity.NotificationList;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

@Component
public class MongoQuary {

    final MongoTemplate mongoTemplate;

    public MongoQuary(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public List<String> getCollection(){
        Set<String> collections = mongoTemplate.getCollectionNames();
        List<String> sensor = new ArrayList<>();
        for (String name : collections){
            if(name.startsWith("lghausys"))
                sensor.add(name);
        }
        return sensor;
    }

    /**
     * 측정소 테이블에 sensor 값이 맵핑 되어 있는 측정소만 리턴 (분석 및 통계 페이지 측정소 null 에러 처리)
     * @return sensor 값이 [] 이 아닌 측정소 리턴
     */
    public List<String> findPlaceSensorNotEmpty() {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("name").as("name")
                .and("sensor").as("sensor");

        MatchOperation where;

        where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("sensor")
                                .not().size(0)
                )
        );

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where
        );

        AggregationResults<HashMap> results = mongoTemplate.aggregate(agg, "place", HashMap.class);

        List<HashMap> result = results.getMappedResults();


        List<String> place = new ArrayList<>();

        for(HashMap map : result){
            place.add((String) map.get("name"));
        }

        return place;
    }

    public Object getNotificationList(String from, String to) {
        MatchOperation where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("up_time")
                                .gte(LocalDateTime.parse(from + "T00:00:00"))
                                .lte(LocalDateTime.parse(to + "T23:59:59"))
                )
        );

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        Aggregation agg = Aggregation.newAggregation(
                where,
                sort
        );

        AggregationResults<NotificationList> results = mongoTemplate.aggregate(agg, "notification_list", NotificationList.class);

        List<NotificationList> result = results.getMappedResults();

        return result;
    }
}
