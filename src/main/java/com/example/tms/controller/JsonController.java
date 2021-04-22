package com.example.tms.controller;


import com.example.tms.entity.Sensor;
import com.example.tms.repository.*;
import com.example.tms.repository.SensorQueryDslRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
public class JsonController {

    @Autowired
    PlaceQueryDslRepository placeRepository;

    @Autowired
    SensorQueryDslRepository sensorRepository;

    @Autowired
    PlaceRepository placeRepository2;

// *********************************************************************************************************************
// Place
// *********************************************************************************************************************

// =====================================================================================================================
// return # Place(name, group, power, sensor) List (select * from place)
// =====================================================================================================================
    @RequestMapping(value = "/getPlaceInfo", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceList(){
        return placeRepository.getPlaceInfo();
    }

// =====================================================================================================================
// param # key : Place.name
// return # Place.Sensor List (select sensor from place where name = ? )
// =====================================================================================================================
    @RequestMapping(value = "/getSensorList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getSensorList(@RequestParam("name") String name){
        return placeRepository.getSensorList(name);
    }


// *********************************************************************************************************************
// Sensor
// *********************************************************************************************************************

// =====================================================================================================================
// param # key : String sensor_name (Place.sensor)
// return # Sensor(value, status, up_time(desc)) List (select * from #Place.sensor order by up_time desc)
// =====================================================================================================================
    @RequestMapping(value = "/getSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor_name){
        return sensorRepository.getSensor(sensor_name);
    }


// =====================================================================================================================
// param # key : String sensor_name (Place.sensor), String limit_amount
// return # Sensor(value, status, up_time(desc)) List (select * from #Place.sensor order by up_time desc limit #limit_amount)
// =====================================================================================================================
    @RequestMapping(value = "/getSensorL", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor_name, @RequestParam("limit") String limit_amount){
        return sensorRepository.getSensor(sensor_name, limit_amount);
    }

    // =================================================================================================================
    // 김규아 추가
    /**
     * 측정소에 맵핑된 센서 테이블 정보를 읽어오기 위한 메소드
     * @param name 측정소 이름
     * @return 해당 측정소의 센서 값 (테이블 명)
     */
    @RequestMapping(value = "/getPlaceSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceSensor(@RequestParam("name") String name){
        return placeRepository2.findByName(name).getSensor();
    }
}
