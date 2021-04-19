package com.example.tms.repository;


import com.example.tms.entity.*;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.repository.support.QuerydslRepositorySupport;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Log4j2
public class PlaceQueryDslRepository extends QuerydslRepositorySupport {

    public PlaceQueryDslRepository(MongoOperations operations) {
        super(operations);
    }

    QPlace qPlace = QPlace.place;

// =====================================================================================================================
// return # Place(name, group, power, sensor) List (select * from place)
// =====================================================================================================================
    public List<Place> getPlaceInfo(){
        List<Place> list = from(qPlace).where().fetch();
        return list;
    }

// =====================================================================================================================
// param # key : Place.name
// return # Place.Sensor List (select sensor from place where name = ? )
// =====================================================================================================================
    public List<String> getSensorList(String name){
        List<Place> list = from(qPlace).where(qPlace.name.eq(name)).fetch();
        List<String> sensor_names = list.get(0).getSensor();
        return sensor_names;
    }

}
