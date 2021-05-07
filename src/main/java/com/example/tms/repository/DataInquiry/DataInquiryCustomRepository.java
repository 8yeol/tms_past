package com.example.tms.repository.DataInquiry;

import com.example.tms.entity.ChartData;
import com.example.tms.entity.Sensor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public class DataInquiryCustomRepository {
    final MongoTemplate mongoTemplate;

    public DataInquiryCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public List<ChartData> searchChart(String date_start, String date_end, String item, boolean off) {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("x")
                .and("value").as("y")
                .and("status").as("status");

        MatchOperation where;

        if (off == true) {
            // 모든 데이터 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("x")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        } else {
            // status true ( off 아닌 데이터 ) 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("status")
                                    .is(true)
                                    .and("x")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        }

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "x");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                sort
        );

        AggregationResults<ChartData> results = mongoTemplate.aggregate(agg, item, ChartData.class);

        List<ChartData> result = results.getMappedResults();

        return result;
    }

    public List<Sensor> searchInformatin(String date_start, String date_end, String item, boolean off) {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("up_time")
                .and("value").as("value")
                .and("status").as("status");

        MatchOperation where;

        if (off == true) {
            // 모든 데이터 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("up_time")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        } else {
            // status true ( off 아닌 데이터 ) 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("status")
                                    .is(true)
                                    .and("up_time")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        }

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                sort
        );

        AggregationResults<Sensor> results = mongoTemplate.aggregate(agg, item, Sensor.class);

        List<Sensor> result = results.getMappedResults();

        return result;
    }
}
