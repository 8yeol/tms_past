package com.example.tms.repository.MonthlyEmissions;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.*;

@Repository
public class MonthlyEmissionsCustomRepository {
    final MongoTemplate mongoTemplate;

    public MonthlyEmissionsCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * [분석 및 통계 - 통계자료 조회] 스케줄러(매월 1일 전월 기준으로) 돌려서 등록된 모든 센서 데이터의 통계값을 나타내기 위함
     * @param item 테이블명
     * @param from 시작일자
     * @param to 종료일자
     * @return 해당 월의 배출량 통계값 (현재 sum 값으로 사용중. 배출량 계산시 수정)
     */
    public Double addStatisticsData(String item, String from, String to) {

        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("up_time")
                .and("value").as("value")
                .and("status").as("status");

        MatchOperation where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("up_time")
                                .gte(LocalDateTime.parse(from + "T00:00:00"))
                                .lte(LocalDateTime.parse(to + "T23:59:59"))
                )
        );

        GroupOperation groupBy = Aggregation.group().sum("value").as("sum_value");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                groupBy
        );

        AggregationResults<Map> results = mongoTemplate.aggregate(agg, item, Map.class);
        List<Map> result = results.getMappedResults();
        Double data;

        if (result.size() != 0) {
            data = (Double) result.get(0).get("sum_value");
        } else {
            data = 0d;
        }

        return data;
    }
}
