package com.example.tms.mongo;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Component
public class MongoConfig {

    final MongoTemplate mongoTemplate;

    public MongoConfig(MongoTemplate mongoTemplate) {
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
}
