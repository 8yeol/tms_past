package com.example.tms.repository.MonthlyEmissions;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@Repository
public class MonthlyEmissionsCustomRepository {
    final MongoTemplate mongoTemplate;

    public MonthlyEmissionsCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public List<Double> addStatisticsData(int year, String item) {
        int[] months = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
        List<Double> data = new ArrayList();

        for (int i = 0; i < months.length; i++) {
            Map<String, String> map = getLastDay(year, months[i]);
            String from = map.get("from");
            String to = map.get("to");
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
            if (result.size() != 0) {
                data.add((Double) result.get(0).get("sum_value"));
            } else {
                data.add(null);
            }
        }

        return data;
    }

    public Map<String, String> getLastDay(int year, int month) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, String> dayList = new HashMap<>();

        Calendar from = Calendar.getInstance();
        Calendar to = Calendar.getInstance();
        from.set(year, month - 1, 1); //월은 -1해줘야 해당월로 인식

        to.set(from.get(Calendar.YEAR), from.get(Calendar.MONTH), from.getActualMaximum(Calendar.DAY_OF_MONTH));

        dayList.put("from", dateFormat.format(from.getTime()));
        dayList.put("to", dateFormat.format(to.getTime()));

        return dayList;
    }

}
