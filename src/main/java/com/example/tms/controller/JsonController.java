package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.repository.*;
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

    final
    Sensor_InfoRepository sensor_infoRepository;

    final
    Sensor_AlarmRepository sensor_alarmRepository;

    public JsonController(PlaceRepository placeRepository, PlaceCustomRepository placeCustomRepository, SensorRepository sensorRepository, SensorCustomRepository sensorCustomRepository, Sensor_InfoRepository sensor_infoRepository, Sensor_AlarmRepository sensor_alarmRepository) {
        this.placeRepository = placeRepository;
        this.placeCustomRepository = placeCustomRepository;
        this.sensorRepository = sensorRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.sensor_infoRepository = sensor_infoRepository;
        this.sensor_alarmRepository = sensor_alarmRepository;
    }

// *********************************************************************************************************************
// Place
// *********************************************************************************************************************

    // =================================================================================================================
    // 김규아 추가
    /**
     * 측정소에 맵핑된 센서 테이블 정보를 읽어오기 위한 메소드
     * @param place 측정소 이름
     * @return 해당 측정소의 센서 값 (테이블 명)
     */
    @RequestMapping(value = "/getPlaceSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceSensor(@RequestParam("place") String place){
        return placeRepository.findByName(place).getSensor();
    }

    /**
     * @param sensor - 센서명
     * @return - 해당 센서의 센서 정보(한글명, 경고값, ...)
     */
    @RequestMapping(value = "/getSensorInfo")
    public Sensor_Info getSensorInfo(@RequestParam String sensor){
        return sensor_infoRepository.findByName(sensor);
    }

// *********************************************************************************************************************
// Sensor
// *********************************************************************************************************************

    @RequestMapping(value = "/getSensorRecent")
    public Sensor getSensorRecent(@RequestParam("sensor") String sensor){
        return sensorCustomRepository.getSensorRecent(sensor);
    }

    /**
     * @param sensor - 센서명
     * @param from_date,to_date - 입력패턴('', 'Year-Month-Day hh:mm:ss', 'Year-Month-Day', 'hh:mm:ss', 'hh:mm')
     * @param minute 분- (60 - 1hour, 1440 - 24hour, ...)
     * @return - 해당 센서의 파라미터로 부터 받은 값에 따라 조건(날짜 및 시간)의 측정 값
     */
    @RequestMapping(value = "/getSensor")
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor,
                                  @RequestParam("from_date") String from_date,
                                  @RequestParam("to_date") String to_date,
                                  @RequestParam("minute") String minute){
        return sensorCustomRepository.getSenor(sensor, from_date, to_date, minute);
    }
    /**
     * 측정소에 맵핑된 센서 테이블 정보를 읽어오기 위한 메소드
     * @param name 센서 이름
     * @return 해당 센서의 status값
     */
    @RequestMapping(value = "/getSensorAlarm")
    public boolean getSensorAlarm(@RequestParam("name") String name){

        return sensor_alarmRepository.findByName(name).isStatus();
    }
    @RequestMapping(value = "/getStartTime")
    public String getStartTime(@RequestParam("name") String name){

        return sensor_alarmRepository.findByName(name).getStart();
    }
    @RequestMapping(value = "/getEndTime")
    public String getEndTime(@RequestParam("name") String name){

        return sensor_alarmRepository.findByName(name).getEnd();
    }



}
