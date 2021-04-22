package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.repository.*;
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
    SensorCustomRepository sensorRepository;

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

    /**
     * @param sensor (sensor sensor)
     * @param from_date,to_date ('', 'Year-Month-Day hh:mm:ss', 'Year-Month-Day', 'hh:mm:ss', 'hh:mm')
     * @param minute (60 - 1hour, 1440 - 24hour, ...)
     * @return List<Sensor> </sensor>_id, value, status, up_time
     */
    @RequestMapping(value = "/getSensor")
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor,
                                  @RequestParam("from_date") String from_date,
                                  @RequestParam("to_date") String to_date,
                                  @RequestParam("minute") String minute){
        return sensorRepository.getSenor(sensor, from_date, to_date, minute);
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
