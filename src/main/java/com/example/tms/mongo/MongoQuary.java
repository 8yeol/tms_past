package com.example.tms.mongo;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Component;

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

}