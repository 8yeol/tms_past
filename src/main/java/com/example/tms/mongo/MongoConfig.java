package com.example.tms.mongo;

//import com.mongodb.MongoClient;
//import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoIterable;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class MongoConfig {
    /*
    MongoClient client = new MongoClient(new MongoClientURI("mongodb://tms:qwer4321!!@192.168.0.162:27017"));
    MongoDatabase database = client.getDatabase("lghausys");

    public List<String> getCollections(){
        MongoIterable<String> collections = database.listCollectionNames();
        List<String> sensor = new ArrayList<>();
        for (String name : collections){
            if(name.startsWith("lghausys"))
                sensor.add(name);
        }
        return sensor;
    }
    */
}
