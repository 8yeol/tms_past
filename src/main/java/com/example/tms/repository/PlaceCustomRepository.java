package com.example.tms.repository;


import com.example.tms.entity.*;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Log4j2
public class PlaceCustomRepository {

    final MongoTemplate mongoTemplate;

    public PlaceCustomRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }


    public List<Place> getSensorNames(String place){
        try {
        log.info(place);
            ProjectionOperation projectionOperation = Aggregation.project()
                    .andInclude("name")
                    .andInclude("group")
                    .andInclude("power")
                    .and("sensor").as("sensor");
            log.info(projectionOperation);
            /* match - gt:>, gte:>=, lt:<, lte:<=, ne:!*/
            MatchOperation matchOperation = Aggregation.match(new Criteria().andOperator(Criteria.where("name")
                    .is(place)
            ));
            /* fetch */
            Aggregation aggregation = Aggregation.newAggregation(projectionOperation);

            AggregationResults<Place> results = mongoTemplate.aggregate(aggregation, place, Place.class);
            log.info(results);
            List<Place> result = results.getMappedResults();
            log.info(result);
            return result;
        }catch (Exception e){
            log.info(e.getMessage());
        }
        return null;
    }

}
