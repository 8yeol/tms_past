package com.example.tms.mongo;

import com.example.tms.entity.Log;
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

    /**
     * lghausys로 시작하는 table 이름 불러와서 센서명으로 맵핑시켜주기 위함
     * @return lghausys_xxx_xxx 형식의 테이블 리스트
     */
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

        MatchOperation where = Aggregation.match(
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

    /**
     * 알림 리스트 입력받은 시간 내의 센서 목록 불러오기
     * @param from 검색시작시간
     * @param to 검색종료시간
     * @return 검색기간내의 알림목록
     */
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

    public Object pagination(int pageNo, String id) {

        MatchOperation where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("id").is(id)
                )
        );

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "_id");

        SkipOperation skip = Aggregation.skip((pageNo-1)*20);

        LimitOperation limit = Aggregation.limit(20);

        Aggregation agg = Aggregation.newAggregation(
                where,
                sort,
                skip,
                limit
        );

        AggregationResults<Log> results = mongoTemplate.aggregate(agg, "log", Log.class);

        List<Log> result = results.getMappedResults();

        return result;
    }

}
