package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.repository.*;
import lombok.extern.log4j.Log4j2;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;


@RestController
@Log4j2
public class JsonController {

    final PlaceRepository placeRepository;
    final SensorRepository sensorRepository;
    final SensorCustomRepository sensorCustomRepository;
    final ReferenceValueSettingRepository reference_value_settingRepository;
    final NotificationSettingsRepository notification_settingsRepository;
    final NotificationListRepository notificationListRepository;
    final NotificationListCustomRepository notificationListCustomRepository;
    final NotificationStatisticsRepository notification_statisticsRepository;

    final MongoTemplate mongoTemplate;

    public JsonController(PlaceRepository placeRepository, SensorRepository sensorRepository, SensorCustomRepository sensorCustomRepository,
                          ReferenceValueSettingRepository reference_value_settingRepository, NotificationSettingsRepository notification_settingsRepository,
                          NotificationListRepository notificationListRepository, NotificationListCustomRepository notificationListCustomRepository, NotificationStatisticsRepository notification_statisticsRepository, MongoTemplate mongoTemplate) {
        this.placeRepository = placeRepository;
        this.sensorRepository = sensorRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.notificationListRepository = notificationListRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.notification_statisticsRepository = notification_statisticsRepository;
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
    public Object notificationList(@RequestParam("week") String week, @RequestParam("today") String today) {
        MatchOperation where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("up_time")
                                .gte(LocalDateTime.parse(week + "T00:00:00"))
                                .lte(LocalDateTime.parse(today + "T23:59:59"))
                )
        );

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        Aggregation agg = Aggregation.newAggregation(
                where,
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

    //측정소 추가
    @RequestMapping(value = "/savePlace")
    public void savePlace(@RequestParam(value = "name") String name, @RequestParam(value = "location") String location, @RequestParam(value = "admin") String admin,
                          @RequestParam(value = "tel") String tel) {
        Date up_time = new Date();
        String power = "off";
        List sensor = new ArrayList();
        Place savePlace = new Place(name, location, admin, tel, power, up_time, sensor);
        placeRepository.save(savePlace);
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
// *********************************************************************************************************************
// Sensor
// *********************************************************************************************************************

    /**
     * @param sensor - 센서명
     * @return - 해당 센서의 센서 정보(한글명, 경고값, ...)
     */
    @RequestMapping(value = "/getSensorInfo")
    public ReferenceValueSetting getSensorInfo(@RequestParam String sensor) {
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
    public NotificationSettings getNotifyInfo(@RequestParam("name") String name) {

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

        NotificationSettings notification_settings = notification_settingsRepository.findByName(item);
        ObjectId id = notification_settings.get_id();

        NotificationSettings changeSetting = new NotificationSettings(item, from, to, status, up_time);
        changeSetting.set_id(id);

        notification_settingsRepository.save(changeSetting);
    }

    // 여기까지
    @RequestMapping(value = "/getMonitoring")
    public Boolean getMonitoring(@RequestParam("name") String tableName) {
        return reference_value_settingRepository.findByName(tableName).isMonitoring();
    }

    //측정소 상세설정 항목 추가
    @RequestMapping(value = "/saveReference")
    public void saveReference(@RequestParam(value = "name") String name, @RequestParam(value = "naming") String naming) {
        float legal = 0.0f;
        float management = 0.0f;
        float company = 0.0f;
        String power = "off";
        //reference document 생성
        ReferenceValueSetting saveReference = new ReferenceValueSetting(name, naming, legal, company, management, power);
        reference_value_settingRepository.save(saveReference);
        //place 업데이트 시간 수정
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();

        Place updatePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), place.getPower(), new Date(), place.getSensor());
        updatePlace.set_id(id);
        placeRepository.save(updatePlace);
    }

    //측정소 상세설정 항목 삭제
    @RequestMapping(value = "/removeReference")
    public void removeReference(@RequestParam(value = "referenceList[]") List<String> referenceList) {
        System.out.println("111111");
        if (referenceList == null || "".equals(referenceList)) {
            System.out.println("3333");
        } else {
            for (int i = 0; i < referenceList.size(); i++) {
                System.out.println("2222222");
                reference_value_settingRepository.deleteByName(referenceList.get(i));


            }
        }
    }


    /* 알림페이지 일별 데이터 저장 */
    @RequestMapping(value = "saveNotiStatistics")
    public void saveNotiStatistics() {
        List<Place> place = placeRepository.findAll();
        /* 현재 날짜 */
        LocalDate nowDate = LocalDate.now();
        int year = nowDate.getYear();
        int month = nowDate.getMonthValue();
        int day = nowDate.getDayOfMonth();
//        GregorianCalendar cld = new GregorianCalendar(year, month - 1, 1);
//        int lastDay = cld.getActualMaximum(Calendar.DAY_OF_MONTH);

        /* 어제제 데이 삽입 */
        if(false){
            String from_date = String.valueOf(nowDate.minusDays(1));
            for (int i = 0; i < place.size(); i++) {
                List<HashMap> list = notificationListCustomRepository.getCount(place.get(i).getName(), LocalDateTime.parse(from_date + "T00:00:00"), LocalDateTime.parse(from_date + "T23:59:59"));
                try {
                    NotificationStatistics ns = new NotificationStatistics(place.get(i).getName(), from_date, "", (Integer) list.get(0).get("count"));
                    notification_statisticsRepository.save(ns);
//                            log.info(from_date+" : " +list);
                } catch (Exception e) {
                    log.info(e.getMessage());
                }
            }
        } //if

        /* 지난 월 데이터 삽입 */
        if(true) {
            //day == 1;
            String newMonth = null;

            if (month <= 10) {
                newMonth = "0" + String.valueOf(month - 1);
            } else {
                newMonth = String.valueOf(month - 1);
            }
            GregorianCalendar newCld = new GregorianCalendar(year, month - 2, 1);
            int lastDay = newCld.getActualMaximum(Calendar.DAY_OF_MONTH);
            String from_date = year + "-" + newMonth + "-01";
            String to_date = year + "-" + newMonth + "-"+lastDay;
            for (int i = 0; i < place.size(); i++) {
                List<HashMap> list = notificationListCustomRepository.getCount(place.get(i).getName(), LocalDateTime.parse(from_date + "T00:00:00"), LocalDateTime.parse(from_date + "T23:59:59").plusMonths(1));
                try {
                    NotificationStatistics ns = new NotificationStatistics(place.get(i).getName(), from_date, to_date, (Integer) list.get(0).get("count"));
                    notification_statisticsRepository.save(ns);
                    log.info(from_date + " : " + list);
                } catch (Exception e) {
                    log.info(e.getMessage());
                }
            }
        } //if

        /* 1월 ~ 현재 데이터 삽입  */
        if(true) {
            for (int m = 1; m <= month; m++) {
                GregorianCalendar calendar = new GregorianCalendar(year, m - 1, 1);
                int m_lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
                if (m == month) {
                    m_lastDay = day - 1;//( 현재 -1 ) 어제
                }
                for (int d = 1; d <= m_lastDay; d++) {
                    String newMonth, newDay = null;
                    if (m < 10) {
                        newMonth = "0" + String.valueOf(m);
                    } else {
                        newMonth = String.valueOf(m);
                    }
                    if (d < 10) {
                        newDay = "0" + String.valueOf(d);
                    } else {
                        newDay = String.valueOf(d);
                    }
                    String from_date = year + "-" + newMonth + "-" + newDay;

                    for (int i = 0; i < place.size(); i++) {
                        List<HashMap> list = notificationListCustomRepository.getCount(place.get(i).getName(), LocalDateTime.parse(from_date + "T00:00:00"), LocalDateTime.parse(from_date + "T23:59:59"));
                        try {
                            NotificationStatistics ns = new NotificationStatistics(place.get(i).getName(), from_date, "", (Integer) list.get(0).get("count"));
                            notification_statisticsRepository.save(ns);
//                            log.info(from_date+" : " +list);
                        } catch (Exception e) {
                            log.info(e.getMessage());
                        }
                    }
                }
            } //for
        } //if
    }

    @RequestMapping(value = "getNotiStatistics")
    public List<NotificationStatistics> getNotiStatics(@RequestParam("place") String place){
        return notification_statisticsRepository.findByPlace(place);
    }
}
