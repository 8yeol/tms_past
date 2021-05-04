package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.repository.*;
import com.example.tms.repository.Reference_Value_SettingRepository;
import lombok.extern.log4j.Log4j2;
import org.bson.types.ObjectId;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@RestController
@Log4j2
public class JsonController {

    final PlaceRepository placeRepository;
    final PlaceCustomRepository placeCustomRepository;
    final SensorRepository sensorRepository;
    final SensorCustomRepository sensorCustomRepository;
    final Reference_Value_SettingRepository reference_value_settingRepository;
    final Notification_SettingsRepository notification_settingsRepository;
    final NotificationListRepository notificationListRepository;
    final NotificationListCustomRepository notificationListCustomRepository;
    final Notification_StatisticsRepository notification_statisticsRepository;

    final MongoTemplate mongoTemplate;

    public JsonController(PlaceRepository placeRepository, PlaceCustomRepository placeCustomRepository, SensorRepository sensorRepository, SensorCustomRepository sensorCustomRepository, Reference_Value_SettingRepository sensor_infoRepository, Reference_Value_SettingRepository reference_value_settingRepository, Notification_SettingsRepository notification_settingsRepository, NotificationListRepository notificationListRepository, MongoTemplate mongoTemplate) {
        this.placeRepository = placeRepository;
        this.placeCustomRepository = placeCustomRepository;
        this.sensorRepository = sensorRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.notificationListRepository = notificationListRepository;
        this.mongoTemplate = mongoTemplate;
    }

// *********************************************************************************************************************
// Place
// *********************************************************************************************************************

    // =================================================================================================================
    // 김규아 추가

    /**
     * 전체 측정소 정보를 읽어오기 위한 메소드
     *
     * @return 전체 측정소 정보
     */
    @RequestMapping(value = "/getPlaceList")
    public List<Place> getPlaceList() {
        return placeRepository.findAll();
    }

    /**
     * 측정소에 맵핑된 센서 테이블 정보를 읽어오기 위한 메소드
     *
     * @param place 측정소 이름
     * @return 해당 측정소의 센서 값 (테이블 명)
     */
    @RequestMapping(value = "/getPlace", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlace(@RequestParam("place") String place) {
        return placeRepository.findByName(place);
    }

    @RequestMapping(value = "/getPlaceSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceSensor(@RequestParam("place") String place) {
        return placeRepository.findByName(place).getSensor();
    }

    /**
     * 설정된 기준 값을 초과하는 경우 알람 발생 - 해당 발생된 알람의 목록 리스트 (ALL) > 페이징 가능하게 수정할 것.
     *
     * @return 전체 알람 목록
     */
    @RequestMapping(value = "/notificationList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object notificationList() {
        /*
        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        SkipOperation skip = Aggregation.skip((pageNo) * 10);

        LimitOperation limit = Aggregation.limit(10);

        Aggregation agg = Aggregation.newAggregation(
                sort,
                skip,
                limit
        );

        AggregationResults<NotificationList> results = mongoTemplate.aggregate(agg, "notification_list", NotificationList.class);

        List<NotificationList> result = results.getMappedResults();
*/
        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        Aggregation agg = Aggregation.newAggregation(
                sort
        );

        AggregationResults<NotificationList> results = mongoTemplate.aggregate(agg, "notification_list", NotificationList.class);

        List<NotificationList> result = results.getMappedResults();

        return result;
    }

    /**
     * 등록된 전체 센서 리스트중, 모니터링 On 설정된 센서 리스트 불러오기
     *
     * @return 모니터링 on 설정된 센서 리스트
     */
    @RequestMapping(value = "/getMonitoringSensorOn", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getMonitoringSensorOn() {
        return notification_settingsRepository.findByStatusIsTrue();
    }

    /**
     * 설정된 법적기준, 사내기준, 관리기준 목록
     *
     * @param tableName 테이블 명
     * @return 해당 센서에 등록된 법적기준, 사내기준, 관리기준 목록
     */
    @RequestMapping(value = "/getReferenceValue", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getReferenceValue(@RequestParam("tableName") String tableName) {
        return reference_value_settingRepository.findByName(tableName);
    }

    @RequestMapping(value = "/getPlaceName", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceName(@RequestParam("tableName") String tableName) {
        return placeRepository.findBySensorIsIn(tableName).getName();
    }
// *********************************************************************************************************************
// Sensor
// *********************************************************************************************************************

    /**
     * @param sensor - 센서명
     * @return - 해당 센서의 센서 정보(한글명, 경고값, ...)
     */
    @RequestMapping(value = "/getSensorInfo")
    public Reference_Value_Setting getSensorInfo(@RequestParam String sensor) {
        return reference_value_settingRepository.findByName(sensor);
    }

    @RequestMapping(value = "/getSensorRecent")
    public Sensor getSensorRecent(@RequestParam("sensor") String sensor) {
        return sensorCustomRepository.getSensorRecent(sensor);
    }

    /**
     * @param sensor            - 센서명
     * @param from_date,to_date - 입력패턴('', 'Year-Month-Day hh:mm:ss', 'Year-Month-Day', 'hh:mm:ss', 'hh:mm')
     * @param minute            분- (60 - 1hour, 1440 - 24hour, ...)
     * @return - 해당 센서의 파라미터로 부터 받은 값에 따라 조건(날짜 및 시간)의 측정 값
     */
    @RequestMapping(value = "/getSensor")
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor,
                                  @RequestParam("from_date") String from_date,
                                  @RequestParam("to_date") String to_date,
                                  @RequestParam("minute") String minute) {
        return sensorCustomRepository.getSenor(sensor, from_date, to_date, minute);
    }

    //김규아 수정
    @RequestMapping(value = "/getNotifyInfo")
    public Notification_Settings getNotifyInfo(@RequestParam("name") String name) {

        return notification_settingsRepository.findByName(name);
    }

    /**
     * [환경설정 - 알림설정] 변경된 알림 설정 값을 저장하기 위함
     *
     * @param onList  해당 측정소의 센서목록 중 모니터링 on 설정된 센서 목록
     * @param offList 해당 측정소의 센서목록 중 모니터링 off 설정된 센서 목록
     * @param from    알림 시작 시간
     * @param to      알림 종료 시간
     */
    @RequestMapping("/saveNotification")
    public void saveNotification(@RequestParam(value = "onList[]", required = false) List<String> onList,
                                 @RequestParam(value = "offList[]", required = false) List<String> offList,
                                 @RequestParam(value = "from") String from, @RequestParam(value = "to") String to) {
        if (onList == null || "".equals(onList)) {
        } else {
            for (int i = 0; i < onList.size(); i++) {
                saveNotifySetting(onList.get(i), true, from, to);
            }
        }
        if (offList == null || "".equals(offList)) {
        } else {
            for (int i = 0; i < offList.size(); i++) {
                saveNotifySetting(offList.get(i), false, from, to);
            }
        }
    }

    /**
     * [환경설정 - 알림설정] 모니터링 on/off 변경 및 알림 시간 변경
     *
     * @param item   센서 테이블 명
     * @param status 모니터링 상태
     * @param from   알림 시작 시간
     * @param to     알림 종료 시간
     */
    public void saveNotifySetting(String item, boolean status, String from, String to) {
        Date up_time = new Date();

        Notification_Settings notification_settings = notification_settingsRepository.findByName(item);
        ObjectId id = notification_settings.get_id();

        Notification_Settings changeSetting = new Notification_Settings(item, from, to, status, up_time);
        changeSetting.set_id(id);

        notification_settingsRepository.save(changeSetting);
    }

    // 여기까지
    @RequestMapping(value = "/getPower")
    public String getPower(@RequestParam("name") String tableName) {
        return reference_value_settingRepository.findByName(tableName).getPower();
    }
    @RequestMapping(value = "savePlace")
    public void savePlace(@RequestParam(value="name") String name, @RequestParam(value="location") String location, @RequestParam(value="admin") String admin,
                          @RequestParam(value="tel") String tel){
        Date up_time = new Date();
        String power = "off";
        List sensor = new ArrayList();
        Place savePlace = new Place(name, location, admin, tel, power, up_time, sensor);

        placeRepository.save(savePlace);
    }




    @RequestMapping("getNotificationCount")
    public List<HashMap> getCount(@RequestParam("place") String place, @RequestParam("sensor") String sensor,
                                         @RequestParam("grade") String grade,
                                         @RequestParam("from_date") String from_date,
                                         @RequestParam("to_date") String to_date,
                                         @RequestParam("minute") String minute){
        return notificationListCustomRepository.getCount(place, sensor, grade, from_date, to_date, minute);
    }

    @RequestMapping(value = "saveNotiStatistics")
    public void saveNotiStatistics(@RequestParam("place") String place,
                                   @RequestParam("from_date") String from_date,
                                   @RequestParam("to_date") String to_date
                                   ){
//        Place place_name = placeRepository.findAll();


        List<HashMap> list = notificationListCustomRepository.getCount(place, null, null, from_date, to_date, null);

        for(int i=0; i<list.size(); i++){
            Notification_Statistics ns = new Notification_Statistics(place, from_date, to_date, (Integer)list.get(0).get("count"));
            notification_statisticsRepository.save(ns);
        }

    //측정소 삭제
    @RequestMapping(value = "/removePlace")
    public void removePlace(@RequestParam(value = "placeList[]") List<String> placeList) {
        if (placeList == null || "".equals(placeList)) {
        } else {
            for (int i = 0; i < placeList.size(); i++) {
                placeRepository.deleteByName(placeList.get(i));
            }
        }
    }


}
