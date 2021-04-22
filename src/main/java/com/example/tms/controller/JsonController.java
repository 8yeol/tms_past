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

    final
    PlaceRepository placeRepository;
    final
    PlaceCustomRepository placeCustomRepository;

    final
    SensorRepository sensorRepository;
    final
    SensorCustomRepository sensorCustomRepository;

    public JsonController(PlaceRepository placeRepository, PlaceCustomRepository placeCustomRepository, SensorRepository sensorRepository, SensorCustomRepository sensorCustomRepository) {
        this.placeRepository = placeRepository;
        this.placeCustomRepository = placeCustomRepository;
        this.sensorRepository = sensorRepository;
        this.sensorCustomRepository = sensorCustomRepository;
    }

// *********************************************************************************************************************
// Place
// *********************************************************************************************************************

    // =================================================================================================================
    // 김규아 추가
    /**
     * 측정소에 맵핑된 센서 테이블 정보를 읽어오기 위한 메소드
     * @param name 측정소 이름
     * @return 해당 측정소의 센서 값 (테이블 명)
     */
    @RequestMapping(value = "/getPlaceSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceSensor(@RequestParam("name") String name){
        return placeRepository.findByName(name).getSensor();
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
        return sensorCustomRepository.getSenor(sensor, from_date, to_date, minute);
    }






}
