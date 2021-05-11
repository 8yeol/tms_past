package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.repository.*;
import com.example.tms.repository.DataInquiry.DataInquiryRepository;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsRepository;
import lombok.extern.log4j.Log4j2;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

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
    final ItemRepository itemRepository;
    final SensorListRepository sensorListRepository;
    final NotificationStatisticsCustomRepository notificationStatisticsCustomRepository;
    final NotificationDayStatisticsRepository notificationDayStatisticsRepository;
    final NotificationMonthStatisticsRepository notificationMonthStatisticsRepository;
    final MongoTemplate mongoTemplate;

    final DataInquiryRepository dataInquiryCustomRepository;

    final MonthlyEmissionsRepository monthlyEmissionsRepository;

    public JsonController(PlaceRepository placeRepository, SensorRepository sensorRepository, SensorCustomRepository sensorCustomRepository, ReferenceValueSettingRepository reference_value_settingRepository, NotificationSettingsRepository notification_settingsRepository, NotificationListRepository notificationListRepository, NotificationListCustomRepository notificationListCustomRepository, ItemRepository itemRepository, SensorListRepository sensorListRepository, NotificationStatisticsCustomRepository notificationStatisticsCustomRepository, NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, MongoTemplate mongoTemplate, DataInquiryRepository dataInquiryCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository) {
        this.placeRepository = placeRepository;
        this.sensorRepository = sensorRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.notificationListRepository = notificationListRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.itemRepository = itemRepository;
        this.sensorListRepository = sensorListRepository;
        this.notificationStatisticsCustomRepository = notificationStatisticsCustomRepository;
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.mongoTemplate = mongoTemplate;
        this.dataInquiryCustomRepository = dataInquiryCustomRepository;
        this.monthlyEmissionsRepository = monthlyEmissionsRepository;
    }

    // *********************************************************************************************************************
// Place
// *********************************************************************************************************************

    // =================================================================================================================
    // 김규아 추가

    /**
     * 전체 측정소 정보를 읽어오기 위한 메소드
     * @return 전체 측정소 정보
     */
    @RequestMapping(value = "/getPlaceList")
    public List<Place> getPlaceList() {
        return placeRepository.findAll();
    }


    /**
     * 측정소에 맵핑된 센서 테이블 정보를 읽어오기 위한 메소드
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

    //측정소 모니터링 업데이트
    @RequestMapping(value = "/placeMonitoringUpdate")
    public void placeMonitoringUpdate(@RequestParam("name") String name, @RequestParam("check") Boolean check) {
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), check, place.getPower(), new Date(), place.getSensor());
        savePlace.set_id(id);
        placeRepository.save(savePlace);
    }

    @RequestMapping(value = "getSensorList")
    public List<SensorList> getSensorList() { return sensorListRepository.findAll(); }

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
        String power = "OFF";
        Boolean monitoring = false;
        List sensor = new ArrayList();
        Place savePlace = new Place(name, location, admin, tel, monitoring, power, up_time, sensor);
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


    //센서리스트 불러오기
    @RequestMapping(value = "/getSensorList2")
    public List<SensorList> getSensorList2(@RequestParam("place") String place) {
        return sensorListRepository.findByPlace(place);
    }

    //센서리스트 측정항목 불러오기
    @RequestMapping(value = "/getSensorManagementId")
    public String getSensorManagementId(@RequestParam("name") String tablename) {
        return sensorListRepository.findByTableName(tablename);
    }

    // 김규아 추가
    @RequestMapping(value = "/getMonitoringPlace")
    public List<Place> getMonitoringPlace() {
        return placeRepository.findByMonitoringIsTrue();
    }

    /** 선세의 최근 데이터 조회 (limit:1)
     * @return classification, naming, managementId, tableName, upTime, place, status
     */
    @RequestMapping(value = "/getSensorRecent")
    public Sensor getSensorRecent(@RequestParam("sensor") String sensor) {
        return sensorCustomRepository.getSensorRecent(sensor);
    }

    /** 센서의 최근 전 값 조회 (limit:2) -> 조회한 결과 중 2번째 데이터 리턴
     *  @return classification, naming, managementId, tableName, upTime, place, status
     */
    @RequestMapping(value = "/getSensorBeforeData")
    public Sensor getSensorBeforeData(@RequestParam("sensor") String sensor) {
        return sensorCustomRepository.getSensorBeforeData(sensor);
    }

    /**
     * @param sensor            - 센서명
     * @param minute            분- (60 - 1hour, 1440 - 24hour, ...)
     * @return - 해당 센서의 파라미터로 부터 받은 값에 따라 조건(날짜 및 시간)의 측정 값
     */
    @RequestMapping(value = "/getSensor")
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor,
                                  @RequestParam("minute") String minute) {
        return sensorCustomRepository.getSenor(sensor, minute);
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
        if(notification_settingsRepository.findByName(item) != null){
            NotificationSettings notification_settings = notification_settingsRepository.findByName(item);
            ObjectId id = notification_settings.get_id();

            NotificationSettings changeSetting = new NotificationSettings(item, from, to, status, up_time);
            changeSetting.set_id(id);
            notification_settingsRepository.save(changeSetting);
        }else{
            NotificationSettings newSetting = new NotificationSettings(item, from, to, status, up_time);
            notification_settingsRepository.save(newSetting);
        }
    }

    // 측정항목 상세설정 모니터링 on/off
    @RequestMapping(value = "/getMonitoring")
    public Boolean getMonitoring(@RequestParam("name") String tableName) {
        return reference_value_settingRepository.findByName(tableName).getMonitoring();
    }

    //측정소 상세설정 항목 추가
    @RequestMapping(value = "/saveReference")
    public String saveReference(@RequestParam(value = "place") String placename,@RequestParam(value = "name") String name, @RequestParam(value = "naming") String naming) {
        if (reference_value_settingRepository.findByName(name) == null) {

            if(placeRepository.findBySensorIsIn(name) != null){
                //place 업데이트 시간 수정
                Place place = placeRepository.findBySensorIsIn(name);
                ObjectId id = place.get_id();

                Place updatePlace = new Place(place.getName(), place.getLocation(), place.getAdmin(), place.getTel(), place.getMonitoring(), place.getPower(), new Date(), place.getSensor());
                updatePlace.set_id(id);
                placeRepository.save(updatePlace);


            }else{
                Place placesensor = placeRepository.findByName(placename);
                ObjectId id = placesensor.get_id();
                List<String> sensor = placesensor.getSensor();
                sensor.add(name);
                Place updatePlace = new Place(placename, placesensor.getLocation(), placesensor.getAdmin(), placesensor.getTel(), placesensor.getMonitoring(), placesensor.getPower(), new Date(), sensor);
                updatePlace.set_id(id);
                placeRepository.save(updatePlace);

            }
            float legal = 999.0f;
            float management = 999.0f;
            float company = 999.0f;
            Boolean monitoring = false;

            //reference document 생성
            ReferenceValueSetting saveReference = new ReferenceValueSetting(name, naming, legal, company, management, monitoring);
            reference_value_settingRepository.save(saveReference);

            return "success";
        } else {
            return "fail";
        }
    }

    //측정 항목 모니터링 업데이트
    @RequestMapping(value = "/referenceMonitoringUpdate")
    public void referenceMonitoringUpdate(@RequestParam("place") String name, @RequestParam("check") Boolean check, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        ObjectId id1 = reference.get_id();
        ReferenceValueSetting saveReference = new ReferenceValueSetting(tablename, reference.getNaming(), reference.getLegalStandard(), reference.getCompanyStandard(), reference.getManagementStandard(), check);
        saveReference.set_id(id1);
        reference_value_settingRepository.save(saveReference);
        //측정소 업데이트
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), place.getMonitoring(), place.getPower(), new Date(), place.getSensor());
        savePlace.set_id(id);
        placeRepository.save(savePlace);
    }

    //측정 항목 법적기준 업데이트
    @RequestMapping(value = "/legalUpdate")
    public void legalUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        ObjectId id1 = reference.get_id();
        ReferenceValueSetting saveReference = new ReferenceValueSetting(tablename, reference.getNaming(), value, reference.getCompanyStandard(), reference.getManagementStandard(), reference.getMonitoring());
        saveReference.set_id(id1);
        reference_value_settingRepository.save(saveReference);
        //측정소 업데이트
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), place.getMonitoring(), place.getPower(), new Date(), place.getSensor());
        savePlace.set_id(id);
        placeRepository.save(savePlace);
    }

    //측정 항목 사내기준 업데이트
    @RequestMapping(value = "/companyUpdate")
    public void companyUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        ObjectId id1 = reference.get_id();
        ReferenceValueSetting saveReference = new ReferenceValueSetting(tablename, reference.getNaming(), reference.getLegalStandard(), value, reference.getManagementStandard(), reference.getMonitoring());
        saveReference.set_id(id1);
        reference_value_settingRepository.save(saveReference);
        //측정소 업데이트
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), place.getMonitoring(), place.getPower(), new Date(), place.getSensor());
        savePlace.set_id(id);
        placeRepository.save(savePlace);
    }

    //측정 항목 관리기준 업데이트
    @RequestMapping(value = "/managementUpdate")
    public void managementUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        ObjectId id1 = reference.get_id();
        ReferenceValueSetting saveReference = new ReferenceValueSetting(tablename, reference.getNaming(), reference.getLegalStandard(), reference.getCompanyStandard(), value, reference.getMonitoring());
        saveReference.set_id(id1);
        reference_value_settingRepository.save(saveReference);
        //측정소 업데이트
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), place.getMonitoring(), place.getPower(), new Date(), place.getSensor());
        savePlace.set_id(id);
        placeRepository.save(savePlace);
    }

    //측정소 상세설정 항목 삭제
    @RequestMapping(value = "/removeReference")
    public void removeReference(@RequestParam(value = "referenceList[]") List<String> referenceList) {
        if (referenceList == null || "".equals(referenceList)) {
        } else {
            for (int i = 0; i < referenceList.size(); i++) {
                removeReferencePlaceUpdate(referenceList.get(i));
            }
        }
    }

    //상세설정값 삭제 및 측정소 업데이트 시간 수정
    public void removeReferencePlaceUpdate(String name) {
        //상세설정 값 삭제
        reference_value_settingRepository.deleteByName(name);
        //place 업데이트 시간 수정
        Place place = placeRepository.findBySensorIsIn(name);
        ObjectId id = place.get_id();

        Place updatePlace = new Place(place.getName(), place.getLocation(), place.getAdmin(), place.getTel(), place.getMonitoring(), place.getPower(), new Date(), place.getSensor());
        updatePlace.set_id(id);
        placeRepository.save(updatePlace);

    }

    /** 알림 현황 저장 (일 - 1월1부터 ~ 어제 날짜 / 월 - 1월1부터 이번달)
     *  notification_day_statistics(일) , notification_month_statistics(월)
     */
    @RequestMapping(value = "saveNotiStatistics")
    public void saveNotiStatistics() {
        LocalDate nowDate = LocalDate.now(); //현재시간
        int getYear = nowDate.getYear();
        int getMonth = nowDate.getMonthValue();
        int getDay = nowDate.getDayOfMonth();
        LocalDate getYesterday = nowDate.minusDays(1);
        LocalDate getLastMonth = nowDate.minusMonths(1);

        /* 일 데이터 및 월 데이터 입력: 1월1일 ~ 어제 날짜 */
        for (int m = 1; m <= getMonth; m++) {
            LocalDate date = LocalDate.of(getYear, m, 1);
            int lastDay = date.lengthOfMonth();
            if (m == getMonth) { // 이번 달, 어제 날짜까지 구하기 위함
                lastDay = getDay - 1;
            }
            for (int d = 1; d <= lastDay; d++) {
                LocalDate date2 = LocalDate.of(getYear, m, d);
                notificationDayStatisticsRepository.deleteByDay(String.valueOf(date2)); //데이터가 존재할 경우 삭제
                try {
                    int arr[] = new int[3];
                    for (int grade = 1; grade <= 3; grade++) {
                        List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(date2), String.valueOf(date2));
                        arr[grade - 1] = (int) list.get(0).get("count");
                    }
                    NotificationDayStatistics ns = new NotificationDayStatistics(String.valueOf(date2), arr[0], arr[1], arr[2]);
                    notificationDayStatisticsRepository.save(ns);
                } catch (Exception e) {
                    NotificationDayStatistics ns = new NotificationDayStatistics(String.valueOf(date2), 0, 0, 0);
                    notificationDayStatisticsRepository.save(ns);
//                        log.info(e.getMessage());
                }
            }
        }


        /* 월데이터 입력 : 1월 ~ 이번 달 */
        for (int m = 1; m <= getMonth; m++) {
            LocalDate from_date = LocalDate.of(getYear, m, 1);
            LocalDate to_date = LocalDate.of(getYear, m, from_date.lengthOfMonth());
            String date = String.valueOf(from_date).substring(0, 7);
            notificationMonthStatisticsRepository.deleteByMonth(date); //데이터가 존재할 경우 삭제
            try {
                int arr[] = new int[3];
                for (int grade = 1; grade <= 3; grade++) {
                    List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(from_date), String.valueOf(to_date));
                    arr[grade - 1] = (int) list.get(0).get("count");
                }
                NotificationMonthStatistics ns = new NotificationMonthStatistics(date, arr[0], arr[1], arr[2]);
                notificationMonthStatisticsRepository.save(ns);
            } catch (Exception e) {
                NotificationMonthStatistics ns = new NotificationMonthStatistics(date, 0, 0, 0);
                notificationMonthStatisticsRepository.save(ns);
            }
        }

    }

    /** 당일 알림 현황 조회
     * @return day(현재날짜), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNotiStatisticsNow")
    public ArrayList getNotificationStatistics() {
        ArrayList al = new ArrayList();
        try{
            LocalDate nowDate = LocalDate.now();
            al.add(nowDate);
            for(int grade=1; grade<=3; grade++){
                List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(nowDate), String.valueOf(nowDate));
                al.add(list.get(0).get("count"));
            }
        }catch (Exception e){
        }
        return al;
    }


    /** 일별 알림 현황 조회 - 최근 일주일 (limit:7)
     * @return day('yyyy-MM-dd'), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNotificationWeekStatistics")
    public List<NotificationDayStatistics> getNotificationWeekStatistics() {
        return notificationStatisticsCustomRepository.getNotificationWeekStatistics();
    }

    /** 월별 현황 조회 - 최근 1년 (limit:12)
     * @return month('yyyy-MM'), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNotificationMonthStatistics")
    public List<NotificationMonthStatistics> getNotificationMonthStatistics() {
        return notificationStatisticsCustomRepository.getNotificationMonthStatistics();
    }


    //배출기준 추가, 수정
    @RequestMapping(value = "/saveEmissionsStandard")
    public List saveEmissionsStandard(@RequestParam(value = "code") String code, @RequestParam(value = "sensorName") String sensorName, @RequestParam(value = "standard") int standard,@RequestParam(value = "hiddenCode" ,required=false) String hiddenCode,
                                      @RequestParam(value = "percent") int percent, @RequestParam(value = "formula") String formula) {

        Item setting;

        //hidden 값이 있는지로 추가와 수정을 판별
        if(hiddenCode==""||hiddenCode==null){
            setting = new Item();
        }else{
            setting = itemRepository.findBySensorCode(hiddenCode);
        }

        setting.setItem(code);
        setting.setItemName(sensorName);
        setting.setEmissionsStandard(standard);
        setting.setDensityStandard(percent);
        setting.setFormula(formula);
        itemRepository.save(setting);

        List<Item> standardList =  itemRepository.findAll();
        return standardList;
    }
    //배출기준 삭제
    @RequestMapping(value = "/deleteEmissionsStandard")
    public List deleteEmissionsStandard(@RequestParam(value = "code") String code) {

        Item setting;

        setting = itemRepository.findBySensorCode(code);

        itemRepository.delete(setting);

        List<Item> standardList =  itemRepository.findAll();
        return standardList;
    }

    @RequestMapping(value = "/searchChart", method = RequestMethod.POST)
    public List<ChartData> searchChart(String date_start, String date_end, String item, boolean off) {

        return dataInquiryCustomRepository.searchChart(date_start, date_end, item, off);
    }

    @RequestMapping(value = "/searchInformatin", method = RequestMethod.POST)
    public List<Sensor> searchInformatin(String date_start, String date_end, String item, boolean off) {

        return dataInquiryCustomRepository.searchInformatin(date_start, date_end, item, off);
    }
    //센서관리 항목 추가,수정
    @RequestMapping(value = "/saveSensor")
    public void saveSensor(@RequestParam(value = "managementId") String managementId, @RequestParam(value = "classification") String classification, @RequestParam(value = "naming") String naming,@RequestParam(value = "place") String place,
                           @RequestParam(value = "tableName") String tableName,@RequestParam(value = "hiddenCode" ,required=false) String hiddenCode) {

        SensorList sensor;

        //hidden 값이 있는지로 추가와 수정을 판별
        if(hiddenCode==""||hiddenCode==null){
            sensor = new SensorList();
        }else{
            sensor = sensorListRepository.findByTableName(tableName,"");
        }

        sensor.setClassification(classification);
        sensor.setManagementId(managementId);
        sensor.setNaming(naming);
        sensor.setPlace(place);
        sensor.setTableName(tableName);
        sensor.setUpTime(new Date());
        sensor.setStatus(true);

        sensorListRepository.save(sensor);
    }

    //센서관리 삭제
    @RequestMapping(value = "/deleteSensor")
    public void deleteSensor(String tableName) {

       SensorList sensor = sensorListRepository.findByTableName(tableName,"");
       sensorListRepository.delete(sensor);

    }

    @RequestMapping(value = "/getStatisticsData", method = RequestMethod.POST)
    public MonthlyEmissions getStatisticsData(String sensor, int year) {

        return monthlyEmissionsRepository.findBySensorAndYear(sensor, year);
    }

    @RequestMapping(value = "/getNaming")
    public List getNaming() {
        return itemRepository.findAll();
    }

}
