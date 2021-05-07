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
