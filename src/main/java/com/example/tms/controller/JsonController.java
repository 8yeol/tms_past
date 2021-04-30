package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.repository.*;
import com.example.tms.repository.Reference_Value_SettingRepository;
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

    final
    Reference_Value_SettingRepository reference_value_settingRepository;

    final
    Notification_SettingsRepository notification_settingsRepository;

    @Autowired
    NotificationListRepository notificationListRepository;

    public JsonController(PlaceRepository placeRepository, PlaceCustomRepository placeCustomRepository, SensorRepository sensorRepository, SensorCustomRepository sensorCustomRepository, Reference_Value_SettingRepository sensor_infoRepository, Reference_Value_SettingRepository reference_value_settingRepository, Notification_SettingsRepository notification_settingsRepository) {
        this.placeRepository = placeRepository;
        this.placeCustomRepository = placeCustomRepository;
        this.sensorRepository = sensorRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notification_settingsRepository = notification_settingsRepository;
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

    @RequestMapping(value = "/notificationList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object notificationList(){
        return notificationListRepository.findAll();
    }

// *********************************************************************************************************************
// Sensor
// *********************************************************************************************************************
    /**
     * @param sensor - 센서명
     * @return - 해당 센서의 센서 정보(한글명, 경고값, ...)
     */
    @RequestMapping(value = "/getSensorInfo")
    public Reference_Value_Setting getSensorInfo(@RequestParam String sensor){
        return reference_value_settingRepository.findByName(sensor);
    }

    @RequestMapping(value = "/getSensorInfo2")
    public Reference_Value_Setting getSensorInfo2(@RequestParam String sensor, @RequestParam String power){
        return reference_value_settingRepository.findByNameAndPower(sensor, power);
    }

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
    @RequestMapping(value = "/getNotification")
    public boolean getSensorAlarm(@RequestParam("name") String name){

        return notification_settingsRepository.findByName(name).isStatus();
    }
    
    //설정된 알람 시간
    @RequestMapping(value = "/getNotifyTime")
    public Notification_Settings getStartTime(@RequestParam("name") String name){

        return notification_settingsRepository.findByName(name);
    }

    //모니터링 on/off 여부
    @RequestMapping(value = "/getPower")
    public String getPower(@RequestParam("name") String name){

        try{
            return reference_value_settingRepository.findByName(name).getPower();

        }catch (NullPointerException e){
            return "null";
        }
    }

    //법적기준
    @RequestMapping(value = "/getLegal")
    public Float getLegal(@RequestParam("name") String name){
        try{
            return reference_value_settingRepository.findByName(name).getLegal_standard();

        }catch (NullPointerException e){
            return 0.0f;
        }
    }
    //사내기준
    @RequestMapping(value = "/getCompany")
    public Float getCompany(@RequestParam("name") String name){
        try{
            return reference_value_settingRepository.findByName(name).getCompany_standard();

        }catch (NullPointerException e){
            return 0.0f;
        }
    }
    //관리기준
    @RequestMapping(value = "/getManagement")
    public Float getManagement(@RequestParam("name") String name){
        try{
            return reference_value_settingRepository.findByName(name).getManagement_standard();

        }catch (NullPointerException e){
            return 0.0f;
        }
    }

}
