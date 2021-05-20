package com.example.tms.controller;


import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.repository.DataInquiry.DataInquiryRepository;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsRepository;
import com.example.tms.service.MemberService;
import com.example.tms.service.RankManagementService;
import lombok.extern.log4j.Log4j2;
import org.bson.types.ObjectId;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.security.Principal;
import java.time.LocalDate;
import java.util.*;


@RestController
@Log4j2
public class AjaxController {

    final PlaceRepository placeRepository;
    final SensorCustomRepository sensorCustomRepository;
    final ReferenceValueSettingRepository reference_value_settingRepository;
    final NotificationSettingsRepository notification_settingsRepository;
    final NotificationListCustomRepository notificationListCustomRepository;
    final EmissionsStandardSettingRepository emissionsStandardSettingRepository;
    final SensorListRepository sensorListRepository;
    final NotificationStatisticsCustomRepository notificationStatisticsCustomRepository;
    final NotificationDayStatisticsRepository notificationDayStatisticsRepository;
    final NotificationMonthStatisticsRepository notificationMonthStatisticsRepository;
    final AnnualEmissionsRepository annualEmissionsRepository;
    final EmissionsSettingRepository emissionsSettingRepository;
    final DataInquiryRepository dataInquiryCustomRepository;
    final MonthlyEmissionsRepository monthlyEmissionsRepository;
    final ItemRepository itemRepository;
    final MongoQuary mongoQuary;
    final LogRepository logRepository;
    final EmissionsTransitionRepository emissionsTransitionRepository;

    final MemberRepository memberRepository;
    final MemberService memberService;
    final RankManagementRepository rankManagementRepository;
    final RankManagementService rankManagementService;

    final PasswordEncoder passwordEncoder;

    public AjaxController(PlaceRepository placeRepository,EmissionsTransitionRepository emissionsTransitionRepository, LogRepository logRepository, SensorCustomRepository sensorCustomRepository, ReferenceValueSettingRepository reference_value_settingRepository, NotificationSettingsRepository notification_settingsRepository, NotificationListCustomRepository notificationListCustomRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, NotificationStatisticsCustomRepository notificationStatisticsCustomRepository, NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, AnnualEmissionsRepository annualEmissionsRepository, EmissionsSettingRepository emissionsSettingRepository, DataInquiryRepository dataInquiryCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, ItemRepository itemRepository, MongoQuary mongoQuary, MemberRepository memberRepository, MemberService memberService, RankManagementRepository rankManagementRepository, RankManagementService rankManagementService, PasswordEncoder passwordEncoder) {
        this.placeRepository = placeRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.emissionsStandardSettingRepository = emissionsStandardSettingRepository;
        this.sensorListRepository = sensorListRepository;
        this.notificationStatisticsCustomRepository = notificationStatisticsCustomRepository;
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.annualEmissionsRepository = annualEmissionsRepository;
        this.emissionsSettingRepository = emissionsSettingRepository;
        this.dataInquiryCustomRepository = dataInquiryCustomRepository;
        this.monthlyEmissionsRepository = monthlyEmissionsRepository;
        this.itemRepository = itemRepository;
        this.mongoQuary = mongoQuary;
        this.logRepository = logRepository;
        this.memberRepository = memberRepository;
        this.memberService = memberService;
        this.rankManagementRepository = rankManagementRepository;
        this.rankManagementService = rankManagementService;
        this.passwordEncoder = passwordEncoder;
        this.emissionsTransitionRepository = emissionsTransitionRepository;
    }

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
     * @return 해당 측정소 정보
     */
    @RequestMapping(value = "/getPlace")
    public Object getPlace(String place) {
        return placeRepository.findByName(place);
    }

    /**
     * 해당 측정소 명에 등록된 센서 리스트 목록
     *
     * @param place 측정소명
     * @return 해당 측정소에 등록된 센서 값
     */
    @RequestMapping(value = "/getPlaceSensor")
    public Object getPlaceSensor(String place) {
        return placeRepository.findByName(place).getSensor();
    }

    /**
     * 측정소 모니터링 업데이트
     *
     * @param name  측정소명
     * @param check 모니터링 true/false
     */
    @RequestMapping(value = "/MonitoringUpdate")
    public void MonitoringUpdate(@RequestParam("place") String name, @RequestParam("check") Boolean check) {
        Place place = placeRepository.findByName(name);
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), check, new Date(), place.getSensor());
        savePlace.set_id(id);
        placeRepository.save(savePlace);
    }

    /**
     * 측정항목 모니터링 변경
     * 현재 모니터링값 반대로 적용
     *
     * @param name      측정소명
     * @param tablename 센서명
     */
    @RequestMapping(value = "/referenceMonitoringUpdate")
    public void referenceMonitoringUpdate(@RequestParam("place") String name, @RequestParam("sensor") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setMonitoring(!reference.getMonitoring());
        reference_value_settingRepository.save(reference);
        //측정소 업데이트
        placeUpTime(name);
    }

    /**
     * 전체 센서 정보 리스트
     *
     * @return 전체 센서 정보보
     */
    @RequestMapping(value = "getSensorList")
    public List<SensorList> getSensorList() {
        return sensorListRepository.findAll();
    }

    /**
     * 설정된 기준 값을 초과하는 경우 알람 발생 - 해당 발생된 알람의 목록 리스트 (from - to 사이 데이터)
     *
     * @return 전체 알람 목록
     */
    @RequestMapping(value = "/getNotificationList")
    public Object getNotificationList(String from, String to) {
        return mongoQuary.getNotificationList(from, to);
    }

    /**
     * 등록된 전체 센서 리스트중, 모니터링 On 설정된 센서 리스트 불러오기
     *
     * @return 모니터링 on 설정된 센서 리스트
     */
    @RequestMapping(value = "/getMonitoringSensorOn", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getMonitoringSensorOn() {
        return reference_value_settingRepository.findByMonitoringIsTrue();
    }

    /**
     * 넘겨받은 센서명이 포함된 측정소 이름 받아오기
     *
     * @param tableName 센서명
     * @return 센서명이 포함된 측정소 이름
     */
    @RequestMapping(value = "/getPlaceName", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getPlaceName(@RequestParam("tableName") String tableName) {
        return placeRepository.findBySensorIsIn(tableName).getName();
    }

    /**
     * 측정소 추가, 수정
     * 수정시 센서 상세설정에서 측정소명도 같이 변경
     *
     * @param name       측정소명
     * @param location   위치
     * @param admin      담당자 명
     * @param tel        연락처
     * @param hiddenCode 수정하고 싶은 측정소명명
     */
    @RequestMapping(value = "/savePlace")
    public void savePlace(@RequestParam(value = "name") String name, @RequestParam(value = "location") String location, @RequestParam(value = "admin") String admin,
                          @RequestParam(value = "tel") String tel, @RequestParam(value = "hiddenCode") String hiddenCode) {
        Date date = new Date();
        if (hiddenCode == "" || hiddenCode == null) { //추가
            Boolean monitoring = false;
            List sensor = new ArrayList();
            Place newplace = new Place(name, location, admin, tel, monitoring, date, sensor);
            placeRepository.save(newplace);
        } else { //수정
            Place place = placeRepository.findByName(hiddenCode); //기존 측정소 정보 불러오기
            place.setName(name);
            place.setUp_time(date);
            place.setLocation(location);
            place.setAdmin(admin);
            place.setTel(tel);
            placeRepository.save(place);

            List<SensorList> sensorlist = sensorListRepository.findByPlace(hiddenCode);
            for (int i = 0; i < sensorlist.size(); i++) {
                SensorList sensor = sensorlist.get(i);
                sensor.setPlace(name);
                sensor.setUpTime(date);
                sensorListRepository.save(sensor);
            }

            List<EmissionsStandardSetting> ess = emissionsStandardSettingRepository.findByPlace(hiddenCode);
            for (int i = 0; i < ess.size(); i++) {
                ess.get(i).setPlace(name);
                emissionsStandardSettingRepository.save(ess.get(i));
            }
            List<AnnualEmissions> ae = annualEmissionsRepository.findByPlace(hiddenCode);
            for (int i = 0; i < ae.size(); i++) {
                ae.get(i).setPlace(name);
                annualEmissionsRepository.save(ae.get(i));
            }
            List<EmissionsSetting> es = emissionsSettingRepository.findByPlace(hiddenCode);
            for (int i = 0; i < es.size(); i++) {
                es.get(i).setPlace(name);
                emissionsSettingRepository.save(es.get(i));
            }
            List<EmissionsTransition> et = emissionsTransitionRepository.findByPlaceName(hiddenCode);
            for (int i = 0; i < et.size(); i++) {
                et.get(i).setPlaceName(name);
                emissionsTransitionRepository.save(et.get(i));
            }



        }
    }

    /**
     * 측정소 +센서 삭제, 측정소만 삭제를 판별
     *
     * @param placeList 측정소 배열
     * @param flag      어떻게 삭제할지 판별할 데이터
     */
    @RequestMapping(value = "/removePlace")
    public void removePlace(@RequestParam(value = "placeList[]") List<String> placeList, boolean flag) {

        for (int i = 0; i < placeList.size(); i++) {
            if (flag) {
                removePlaceRemoveSensor(placeList.get(i));       //센서 포함 삭제
            } else {
                removePlaceChangeSensor(placeList.get(i));       //측정소만 삭제
            }
        }
    }

    /**
     * 측정소만 삭제 , 센서는 측정소명 ""으로 변경, 상세설정 비활성화
     *
     * @param place 측정소명
     */
    public void removePlaceChangeSensor(String place) {
        Place placeInfo = placeRepository.findByName(place);

        List<String> sensor = placeInfo.getSensor();
        for (int i = 0; i < sensor.size(); i++) {
            //알림설정 False 설정
            NotificationSettings no = notification_settingsRepository.findByName(sensor.get(i));
            if (no != null) {
                no.setStatus(false);
                notification_settingsRepository.save(no);
            }

            //배출량 관리 - 모니터링 대상 False 설정
            EmissionsSetting em = emissionsSettingRepository.findBySensor(sensor.get(i));
            if (em != null) {
                em.setStatus(false);
                em.setPlace("");
                emissionsSettingRepository.save(em);
            }

            //배출량 관리 - 연간 모니터링 대상 False 설정
            AnnualEmissions aem = annualEmissionsRepository.findBySensor(sensor.get(i));
            if (aem != null) {
                aem.setStatus(false);
                aem.setPlace("");
                annualEmissionsRepository.save(aem);
            }

            //센서 관리 - 측정소 값 삭제
            SensorList sl = sensorListRepository.findByTableName(sensor.get(i), "");
            if (sl != null) {
                sl.setPlace("");
                sensorListRepository.save(sl);
            }

            //상세설정 모니터링 값 False
            ReferenceValueSetting rv = reference_value_settingRepository.findByName(sensor.get(i));
            if (rv != null) {
                rv.setMonitoring(false);
                reference_value_settingRepository.save(rv);
            }

            //배출 관리 기준 측정소값 삭제
            EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(sensor.get(i));
            if (ess != null) {
                ess.setPlace("");
                emissionsStandardSettingRepository.save(ess);
            }

            //분기별 배출량 측정소 변경
            EmissionsTransition et = emissionsTransitionRepository.findByTableName(sensor.get(i));
            if(et != null){
                et.setPlaceName("");
                emissionsTransitionRepository.save(et);
            }

        }
        //측정소 삭제
        placeRepository.deleteByName(place);
    }
    /**
     * 측정소와 센서,상세설정값 동시에 삭제
     *
     * @param place 측정소명
     */
    public void removePlaceRemoveSensor(String place) {
        Place placeInfo = placeRepository.findByName(place);
        List<String> sensor = placeInfo.getSensor();
        for (int i = 0; i < sensor.size(); i++) {
            //상세설정 값 삭제
            reference_value_settingRepository.deleteByName(sensor.get(i));
            //알림설정값 삭제
            notification_settingsRepository.deleteByName(sensor.get(i));
            //배출량 관리 - 모니터링 대상 삭제
            emissionsSettingRepository.deleteBySensor(sensor.get(i));
            //배출량 관리 - 연간 모니터링 대상 삭제
            annualEmissionsRepository.deleteBySensor(sensor.get(i));
            //배출 관리 기준 삭제
            emissionsStandardSettingRepository.deleteByTableName(sensor.get(i));
            //센서 관리 - 센서 삭제
            sensorListRepository.deleteByTableName(sensor.get(i));
            // 분석 및 통계 - 통계자료 조회 데이터 삭제
            monthlyEmissionsRepository.deleteBySensor(sensor.get(i));
            //분기별 배출량 정보 삭제
            emissionsTransitionRepository.deleteByTableName(sensor.get(i));
        }
        //측정소 삭제
        placeRepository.deleteByName(place);
    }

    /**
     * 설정된 법적기준, 사내기준, 관리기준 목록, 모니터링 true/false
     *
     * @param sensor 센서명
     * @return 해당 센서에 등록된 법적기준, 사내기준, 관리기준 목록, 모니터링 true/false
     */
    @RequestMapping(value = "/getSensorInfo")
    public ReferenceValueSetting getSensorInfo(String sensor) {
        return reference_value_settingRepository.findByName(sensor);
    }

    /**
     * 테이블 명으로 센서 가져오기
     *
     * @param tablename 테이블명
     * @return 센서
     */
    @RequestMapping(value = "/getSensorManagementId")
    public String getSensorManagementId(@RequestParam("name") String tablename) {
        return sensorListRepository.findByTableName(tablename);
    }
    /**
     * 선세의 최근 데이터 조회 (limit:1)
     *
     * @return classification, naming, managementId, tableName, upTime, place, status
     */
    @RequestMapping(value = "/getSensorRecent")
    public Sensor getSensorRecent(@RequestParam("sensor") String sensor) {
        return sensorCustomRepository.getSensorRecent(sensor);
    }

    /**
     * 센서의 최근 전 값 조회 (limit:2) -> 조회한 결과 중 2번째 데이터 리턴
     *
     * @return classification, naming, managementId, tableName, upTime, place, status
     */
    @RequestMapping(value = "/getSensorBeforeData")
    public Sensor getSensorBeforeData(@RequestParam("sensor") String sensor) {
        return sensorCustomRepository.getSensorBeforeData(sensor);
    }

    /**
     * @param sensor - 센서명
     * @param hour   시간
     * @return - 해당 센서의 파라미터로 부터 받은 값에 따라 조건(날짜 및 시간)의 측정 값
     */
    @RequestMapping(value = "/getSensor")
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor,
                                  @RequestParam("hour") String hour) {
        return sensorCustomRepository.getSenor(sensor, hour);
    }

    /**
     * 센서 알림설정 ON/OFF 확인
     *
     * @param name 센서명
     * @return 센서 알림설정 true/false
     */
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
        if (notification_settingsRepository.findByName(item) != null) {
            NotificationSettings notification_settings = notification_settingsRepository.findByName(item);
            ObjectId id = notification_settings.get_id();

            NotificationSettings changeSetting = new NotificationSettings(item, from, to, status, up_time);
            changeSetting.set_id(id);
            notification_settingsRepository.save(changeSetting);
        } else {
            NotificationSettings newSetting = new NotificationSettings(item, from, to, status, up_time);
            notification_settingsRepository.save(newSetting);
        }
    }

    /**
     * 센서 모니터링 상태 조회 메소드
     *
     * @param tableName 센서명
     * @return true / false
     */
    @RequestMapping(value = "/getMonitoring")
    public Boolean getMonitoring(@RequestParam("name") String tableName) {
        try {
            return reference_value_settingRepository.findByName(tableName).getMonitoring();
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 측정소 업데이트, 센서 추가
     *
     * @param placename 측정소
     * @param name 센서명
     * @param naming 센서 네이밍
     */
    public void saveReference(String placename, String name, String naming) {

        if (placeRepository.findBySensorIsIn(name) != null) { //기존 센서가 존재
            //place 업데이트 시간 수정
            placeUpTime(placename);
        } else { //최초 입력
            Place placesensor = placeRepository.findByName(placename);
            List<String> sensor = placesensor.getSensor();
            sensor.add(name);
            placesensor.setSensor(sensor);
            placeRepository.save(placesensor);
        }
        float legal = 999.0f;
        float management = 999.0f;
        float company = 999.0f;
        Boolean monitoring = false;

        //reference document 생성
        ReferenceValueSetting saveReference = new ReferenceValueSetting(name, naming, legal, company, management, monitoring);
        reference_value_settingRepository.save(saveReference);
    }

    /**
     * 측정항목의 법적기준 업데이트
     *
     * @param name      측정소명
     * @param value     사내기준 값
     * @param tablename 테이블 명
     */
    @RequestMapping(value = "/legalUpdate")
    public void legalUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setLegalStandard(value);
        reference_value_settingRepository.save(reference);
        //측정소 업데이트
        placeUpTime(name);
    }

    /**
     * 측정항목의 사내기준 업데이트
     *
     * @param name      측정소명
     * @param value     사내기준 값
     * @param tablename 테이블 명
     */
    @RequestMapping(value = "/companyUpdate")
    public void companyUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setCompanyStandard(value);
        reference_value_settingRepository.save(reference);
        //측정소 업데이트
        placeUpTime(name);
    }

    /**
     * 측정항목의 관리기준 업데이트
     *
     * @param name      측정소명
     * @param value     관리기준 값
     * @param tablename 테이블 명
     */
    @RequestMapping(value = "/managementUpdate")
    public void managementUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setManagementStandard(value);
        reference_value_settingRepository.save(reference);
        //측정소 업데이트
        placeUpTime(name);
    }

    /**
     * 측정소 업데이트시간 변경
     *
     * @param name 측정소명
     */
    @RequestMapping(value = "/placeUpTime")
    public void placeUpTime(String name) {
        Place place = placeRepository.findByName(name);
        place.setUp_time(new Date());
        placeRepository.save(place);
    }

    /**
     * 알림 현황 저장 (일 - 1월1부터 ~ 어제 날짜 / 월 - 1월1부터 이번달)
     * notification_day_statistics(일) , notification_month_statistics(월)
     */
    @RequestMapping(value = "saveNS")
    public ArrayList saveNotiStatistics() {
        ArrayList al = new ArrayList();
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
                        if (list.size() != 0) {
                            arr[grade - 1] = (int) list.get(0).get("count");
                        } else {
                            arr[grade - 1] = 0;
                        }
                    }
                    NotificationDayStatistics ns = new NotificationDayStatistics(String.valueOf(date2), arr[0], arr[1], arr[2]);
                    al.add(date2 + ", " + arr[0] + ", " + arr[1] + ", " + arr[2]);
                    notificationDayStatisticsRepository.save(ns);
                } catch (Exception e) {
                    NotificationDayStatistics ns = new NotificationDayStatistics(String.valueOf(date2), 0, 0, 0);
                    notificationDayStatisticsRepository.save(ns);
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
                    if (list.size() != 0) {
                        arr[grade - 1] = (int) list.get(0).get("count");
                    } else {
                        arr[grade - 1] = 0;
                    }
                }
                NotificationMonthStatistics ns = new NotificationMonthStatistics(date, arr[0], arr[1], arr[2]);
                al.add(date + ", " + arr[0] + ", " + arr[1] + ", " + arr[2]);
                notificationMonthStatisticsRepository.save(ns);
            } catch (Exception e) {
                NotificationMonthStatistics ns = new NotificationMonthStatistics(date, 0, 0, 0);
                notificationMonthStatisticsRepository.save(ns);
            }
        }
        return al;
    }

    /**
     * 당일 알림 현황 조회 메소드
     *
     * @return day(현재날짜), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNSNow")
    public ArrayList getNotificationStatistics() {
        ArrayList al = new ArrayList();
        try {
            LocalDate nowDate = LocalDate.now();
            al.add(nowDate);
            for (int grade = 1; grade <= 3; grade++) {
                List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(nowDate), String.valueOf(nowDate));
                if (list.size() != 0) {
                    al.add(list.get(0).get("count"));
                } else {
                    al.add(null);
                }
            }
        } catch (Exception e) {
        }
        return al;
    }


    /**
     * 일별 알림 현황 조회 - 최근 일주일 (limit:7)
     *
     * @return day(' yyyy - MM - dd '), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNSWeek")
    public List<NotificationDayStatistics> getNotificationWeekStatistics() {
        return notificationStatisticsCustomRepository.getNotificationWeekStatistics();
    }

    /**
     * 월별 현황 조회 - 최근 1년 (limit:12)
     *
     * @return month(' yyyy - MM '), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNSMonth")
    public List<NotificationMonthStatistics> getNotificationMonthStatistics() {
        return notificationStatisticsCustomRepository.getNotificationMonthStatistics();
    }

    /**
     * 배출기준 추가, 수정
     *
     * @param standard        기준값
     * @param hiddenTableName 테이블 명
     * @param percent         허용 기준 농도
     * @param formula         산출식
     * @return
     */
    @RequestMapping(value = "/saveEmissionsStandard")
    public List saveEmissionsStandard(@RequestParam(value = "standard") int standard, @RequestParam(value = "hiddenTableName", required = false) String hiddenTableName,
                                      @RequestParam(value = "percent") int percent, @RequestParam(value = "formula") String formula) {

        EmissionsStandardSetting setting = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenTableName);

        setting.setEmissionsStandard(standard);
        setting.setDensityStandard(percent);
        setting.setFormula(formula);
        emissionsStandardSettingRepository.save(setting);

        List<EmissionsStandardSetting> standardList = emissionsStandardSettingRepository.findAll();
        return standardList;
    }


    /**
     * 배출기준 삭제
     *
     * @param tableName 테이블 명
     * @return 삭제후 모든 데이터 다시 검색
     */
    @RequestMapping(value = "/deleteEmissionsStandard")
    public List deleteEmissionsStandard(@RequestParam(value = "tableName") String tableName) {

        EmissionsStandardSetting setting;

        setting = emissionsStandardSettingRepository.findByTableNameIsIn(tableName);

        emissionsStandardSettingRepository.delete(setting);

        List<EmissionsStandardSetting> standardList = emissionsStandardSettingRepository.findAll();
        return standardList;
    }

    /**
     * 분석 및 통계 - 측정자료 조회
     *
     * @param date_start 시작날짜
     * @param date_end   끝나는 날짜
     * @param item       아이템
     * @param off        off 데이터도 표시할 것인지?
     * @return 차트에 활용할 날짜, 속성값
     */
    @RequestMapping(value = "/searchChart", method = RequestMethod.POST)
    public List<HashMap> searchOnChart(String date_start, String date_end, String item, boolean off) {

        return dataInquiryCustomRepository.searchChart(date_start, date_end, item, off);
    }

    /**
     * 분석 및 통계 - 측정자료 조회
     * 날짜,아이템으로 해당 기간의 데이터 추출
     *
     * @param date_start 시작날짜
     * @param date_end   끝나는 날짜
     * @param item       아이템
     * @param off        off 데이터도 표시할 것인지?
     * @return 해당 아이템의 기간 데이터
     */
    @RequestMapping(value = "/searchInformatin", method = RequestMethod.POST)
    public List<Sensor> searchInformatin(String date_start, String date_end, String item, boolean off) {

        return dataInquiryCustomRepository.searchInformatin(date_start, date_end, item, off);
    }

    /**
     * 센서 추가, 수정  / 센서 상세설정 추가, 수정
     *
     * @param managementId   관리 ID
     * @param classification 센서 분류
     * @param naming         센서 네이밍
     * @param place          측정소
     * @param tableName      테이블 명
     * @param hiddenCode     추가,수정을 판별하는 데이터
     */
    @RequestMapping(value = "/saveSensor")
    public void saveSensor(@RequestParam(value = "managementId", required = false) String managementId, @RequestParam(value = "classification", required = false) String classification, @RequestParam(value = "naming", required = false) String naming, @RequestParam(value = "place") String place,
                           @RequestParam(value = "tableName", required = false) String tableName, @RequestParam(value = "hiddenCode", required = false) String hiddenCode, @RequestParam(value = "isValueDelete", required = false) String isValueDelete) {

        SensorList sensor;
        //hidden 값이 있는지로 추가와 수정을 판별
        //추가
        if (hiddenCode == "" || hiddenCode == null) {

            sensor = new SensorList(classification, naming, managementId, tableName, new Date(), place, true);

            //연간 배출량 누적 모니터랑 대상 && 배출량 추이 모니터링 대상   설정에도 추가합니다.
            AnnualEmissions aEmissions = new AnnualEmissions(place, tableName, naming, 7000000, false);
            annualEmissionsRepository.save(aEmissions);

            EmissionsSetting emissions = new EmissionsSetting(place, tableName, naming, false);
            emissionsSettingRepository.save(emissions);

            saveReference(place, tableName, naming); //상세설정 항목 추가

        } else { //수정
            sensor = sensorListRepository.findByTableName(hiddenCode, "");
            sensor.setPlace(place);

            //연간 배출 모니터링 대상 수정
            AnnualEmissions aemis = annualEmissionsRepository.findBySensor(hiddenCode);
            aemis.setPlace(place);
            aemis.setStatus(false);
            annualEmissionsRepository.save(aemis);

            //배출 모니터링 대상 수정
            EmissionsSetting emis = emissionsSettingRepository.findBySensor(hiddenCode);
            emis.setPlace(place);
            emis.setStatus(false);
            emissionsSettingRepository.save(emis);

            //배출 관리 기준 수정
            EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenCode);
            ess.setPlace(place);
            emissionsStandardSettingRepository.save(ess);

            //분기별 배출량 데이터 수정
            EmissionsTransition et = emissionsTransitionRepository.findByTableName(hiddenCode);
            if(et !=null) {
                et.setPlaceName(place);
                emissionsTransitionRepository.save(et);
            }

            //측정소 센서 삭제 or sensor가 없을때 monitoring false
            //place 업데이트 시간 수정
            Place placeremove = placeRepository.findBySensorIsIn(hiddenCode);
            if (placeremove != null) {
                //센서리스트에서 센서 제거
                placeremove.getSensor().remove(hiddenCode);
                if (placeremove.getSensor().size() == 0) {
                    placeremove.setMonitoring(false);
                }
                placeremove.setUp_time(new Date());
                placeRepository.save(placeremove);
            }

            //센서관련 법적기준,사내기준,관리기준값 사용자 동의하에 삭제
            if (isValueDelete.equals("delete")) {
                ReferenceValueSetting reference = reference_value_settingRepository.findByName(hiddenCode);
                float legal = 999.0f;
                float management = 999.0f;
                float company = 999.0f;
                reference.setLegalStandard(legal);
                reference.setCompanyStandard(company);
                reference.setManagementStandard(management);
                reference.setMonitoring(false);
                reference_value_settingRepository.save(reference);
            }

            //측정소 센서 추가 및 시간 업데이트
            Place placeadd = placeRepository.findByName(place); //측정소 정보
            placeadd.getSensor().add(hiddenCode);
            placeadd.setUp_time(new Date());
            placeRepository.save(placeadd);

            //센서 관련 notification 값 제거
            notification_settingsRepository.deleteByName(hiddenCode);


        }
        sensorListRepository.save(sensor);

    }

    /**
     * 센서 상세설정값 삭제, 센서 삭제
     *
     * @param tableName 테이블 명
     */
    @RequestMapping(value = "/deleteSensor")
    public void deleteSensor(String tableName) {
        //배출량 관리 기준 삭제
        emissionsStandardSettingRepository.deleteByTableName(tableName);

        //상세설정 값 삭제
        if (reference_value_settingRepository.findByName(tableName) != null) {
            reference_value_settingRepository.deleteByName(tableName);
        }
        //분기별 배출량 정보 삭제
        if(emissionsTransitionRepository.findByTableName(tableName) != null){
            emissionsTransitionRepository.deleteByTableName(tableName);
        }

        //알림설정값 삭제
        if (notification_settingsRepository.findByName(tableName) != null) {
            notification_settingsRepository.deleteByName(tableName);
        }
        //place 업데이트 시간 수정
        if (placeRepository.findBySensorIsIn(tableName) != null) {
            Place place = placeRepository.findBySensorIsIn(tableName);
            place.getSensor().remove(tableName); //리스트에서 센서 제거
            place.setUp_time(new Date()); //시간 업데이트
            if (place.getSensor().size() == 0) {
                place.setMonitoring(false);
            }
            placeRepository.save(place);
        }

        //배출량 관리 - 모니터링 대상 삭제
        emissionsSettingRepository.deleteBySensor(tableName);
        //배출량 관리 - 연간 모니터링 대상 삭제
        annualEmissionsRepository.deleteBySensor(tableName);
        // 분석 및 통계 - 통계자료 조회 데이터 삭제
        monthlyEmissionsRepository.deleteBySensor(tableName);

        //센서 삭제
        SensorList sensor = sensorListRepository.findByTableName(tableName, "");
        sensorListRepository.delete(sensor);
    }

    /**
     * 센서와 년도를 넣고 월별 데이터를 추출
     *
     * @param sensor 센서명
     * @param year   년도
     * @return 월별 데이터
     */
    @RequestMapping(value = "/getStatisticsData", method = RequestMethod.POST)
    public MonthlyEmissions getStatisticsData(String sensor, int year) {

        return monthlyEmissionsRepository.findBySensorAndYear(sensor, year);
    }

    /**
     * 센서분류값으로 센서 네이밍 검색
     *
     * @param classification 센서분류
     * @return 센서 네이밍
     */
    @RequestMapping(value = "/getNaming")
    public Item getNaming(String classification) {
        return itemRepository.findByClassification(classification);
    }

    /**
     * 연간 배출 허용기준값 있는지 검사
     *
     * @param tableName 테이블명
     * @return boolean
     */
    @RequestMapping(value = "/isStandardEmpty")
    public boolean isStandardEmpty(String tableName) {
        if (emissionsStandardSettingRepository.findByTableNameIsIn(tableName) == null) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 연간 배출량 허용 기준 수정
     *
     * @param naming    센서 네이밍
     * @param place     측정소
     * @param tableName 테이블명
     */
    @RequestMapping(value = "/saveStandard")
    public void saveStandard(@RequestParam(value = "naming") String naming, @RequestParam(value = "place") String place,
                             @RequestParam(value = "tableName") String tableName) {
        EmissionsStandardSetting ess = new EmissionsStandardSetting(place, naming, 0, 0, tableName, "");
        emissionsStandardSettingRepository.save(ess);
    }
    /**
     * 배출량 모니터링 상태값을 변경
     * @param sensor 상태값 변경할 센서
     * @param isCollection 배출량 추이 모니터링 <->연간 배출량 누적 모니터링   판별할 데이터
     */
    @RequestMapping("emissionsState")
    public void emissionsState(String sensor, boolean isCollection) {
        //배출량 설정
        if (isCollection) {
            EmissionsSetting target = emissionsSettingRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            emissionsSettingRepository.save(target);
            //연간 배출량 설정
        } else {
            AnnualEmissions target = annualEmissionsRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            annualEmissionsRepository.save(target);
        }
    }

    /**
     * 회원가입
     * @param member 가입 회원 정보
     * @return 회원가입 성공여부 (root : 최초가입시 최고 관리자로 지정하기 위함)
     */
    @RequestMapping(value = "/memberJoin")
    public String memberJoinPost(Member member) {
        if (memberRepository.findAll().size() == 0) {
            memberService.memberSave(member, "1");
            if (rankManagementRepository.findAll().size() == 0)
                rankManagementService.defaultRankSetting();
            return "root";
        } else if (!memberRepository.existsById(member.getId())) {
            memberService.memberSave(member, "4");
            return "success";
        } else {
            return "failed";
        }
    }

    /**
     * 회원정보 업데이트
     * @param member 입력한 회원의 정보객체
     * @return 업데이트 성공여부
     */
    @RequestMapping(value = "/memberUpdate")
    public String memberUpdate(Member member) {
        memberService.updateMember(member);
        return "success";
    }

    /**
     * 회원탈퇴
     * @param id 탈퇴할 회원의 ID
     * @return 회원탈퇴 성공여부
     */
    @RequestMapping(value = "/memberOut")
    public String memberOut(String id,String password) {
        Member member =  memberRepository.findById(id);
        if(passwordEncoder.matches(password,member.getPassword())){
            memberService.deleteById(id);
            return "success";
        } else {
            return "fail";
        }
    }

    /**
     * 현재 비밀번호 체크
     * @param id
     * @param password
     * @return
     */
    @RequestMapping(value = "/nowPasswordCheck")
    public String nowPasswordCheck(String id, String password) {
        Member newMember = memberRepository.findById(id);
        if( !passwordEncoder.matches(password,newMember.getPassword())) {
            return "failed";
        } else{
            return "success";
        }
    }

    /**
     * 로그인시 입력받은 사용자 정보를 검사
     * @param member 입력받은 사용자정보 객체
     * @param response 뷰로 문자열을 전달하기위한 변수
     * @throws Exception 예외처리
     */

    @RequestMapping(value = "/loginCheck", method = RequestMethod.POST)
    public void loginCheck( Member member, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        if(!memberRepository.existsById(member.getId())){ // ID가 존재하지않으면
            out.print("id");
        } else if(!passwordEncoder.matches(member.getPassword(),memberRepository.findById(member.getId()).getPassword())){ // password가 틀리면
            out.print("password");
        } else  if (memberRepository.findById(member.getId()).getState().equals("5")){ // 가입거절
            out.print("denie");
        } else  if (memberRepository.findById(member.getId()).getState().equals("4")){ // 가입대기
            out.print("waiting");
        }else {
            Member newMember = memberRepository.findById(member.getId());
            Date time = new Date();
            newMember.setLastLogin(time);
            memberRepository.save(newMember);
        }
    }           // loginCheck
    /**
     * 회원가입신청 한 유저의 승낙 여부를 결정
     * @param id 가입신청한유저의 id
     * @param iNumber 0 - 거부 / 1 - 승인 을나타냄
     * @return 안내메시지를 리턴
     */
    @RequestMapping(value = "/signUp", method = RequestMethod.POST)
    public String memberSignUp(String id, String iNumber){
        String msg = "";
        Member newMember = memberRepository.findById(id);
        if(iNumber.equals("0")){
            newMember.setState("5");
            msg = "가입 거절 되었습니다.";
        }else{
            newMember.setState("3"); // 5: 거절 - 4: 가입대기 - 3: 일반 - 2: 관리자 - 1: 최고관리자
            Date time = new Date();
            newMember.setJoined(time); // 가입승인일 설정
            msg = "가입 승인 되었습니다.";
        }
        memberRepository.save(newMember);
        return msg;
    }           // memberSignUp
    /**
     * 입력받은 값으로 유저의 등급을 결정
     * @param id 등급을 결정할 유저의 id
     * @param value 등급값
     * @return 안내메시지 리턴
     */
    @RequestMapping(value = "/gaveRank", method = RequestMethod.POST)
    public String gaveRank(String id, String value){
        Member newMember = memberRepository.findById(id);
        newMember.setState(value);
        memberRepository.save(newMember);
        return "등급 부여 하였습니다.";
    }           // gaveRank
    /**
     * 입력받은 값으로 유저의 비밀번호를 초기화
     * @param id 초기화할 유저의 id
     * @return 안내메시지와 임시비밀번호 메시지 리턴
     */
    @RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
    public String resetPassword(String id){
        Member newMember = memberRepository.findById(id);
        String uuid = (UUID.randomUUID().toString().replaceAll("-", "")).substring(0,10);
        String encodedPwd = passwordEncoder.encode(uuid);
        newMember.setPassword(encodedPwd);
        memberRepository.save(newMember);
        return "비밀번호가 초기화 되었습니다. \n임시비밀번호 : "+ uuid;
    }           // resetPassword
    /**
     * 입력받은 값으로 유저를 추방
     * @param id 추방할 유저의 id
     * @return 안내메시지 리턴
     */
    @RequestMapping(value = "/kickMember", method = RequestMethod.POST)
    public String kickMember(String id){
        memberRepository.deleteById(id);
        return "추방처리 되었습니다.";
    }           // kickMember
    /**
     * 변경한 권한관리 값들을 저장
     * @param rankManagement 변경한 값들을 담고있는 객체
     * @param response 뷰로문자열을 전달하기위한 변수
     * @throws Exception 예외처리
     */
    @RequestMapping(value = "/rankSettingSave", method = RequestMethod.POST)
    public void rankSettingSave(@RequestBody RankManagement rankManagement, HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        RankManagement newRankManagement = rankManagementRepository.findByName(rankManagement.getName());

        String str = "";
        str += (rankManagement.isDashboard() == newRankManagement.isDashboard()) ? "" : (rankManagement.isDashboard()) ? "대시보드 메뉴열람 권한부여  " : "대시보드 메뉴열람 권한해제  " ;
        str += (rankManagement.isAlarm() == newRankManagement.isAlarm()) ? "" : (rankManagement.isAlarm()) ? "알림 메뉴열람 권한부여  " : "알림 메뉴열람 권한해제  " ;
        str += (rankManagement.isMonitoring() == newRankManagement.isMonitoring()) ? "" : (rankManagement.isMonitoring()) ? "모니터링 메뉴열람 권한부여  " : "모니터링 메뉴열람 권한해제  " ;
        str += (rankManagement.isStatistics() == newRankManagement.isStatistics()) ? "" : (rankManagement.isStatistics()) ? "분석및통계 메뉴열람 권한부여  " : "분석및통계 메뉴열람 권한해제  " ;
        str += (rankManagement.isSetting() == newRankManagement.isSetting()) ? "" : (rankManagement.isSetting()) ? "환경설정 메뉴열람 권한부여" : "환경설정 메뉴열람 권한해제" ;
        out.print(str);

        newRankManagement.setDashboard(rankManagement.isDashboard());
        newRankManagement.setAlarm(rankManagement.isAlarm());
        newRankManagement.setMonitoring(rankManagement.isMonitoring());
        newRankManagement.setStatistics(rankManagement.isStatistics());
        newRankManagement.setSetting(rankManagement.isSetting());
        rankManagementRepository.save(newRankManagement);
    }           // rankSettingSave
    /**
     * 로그정보를 날짜추가후 DB에 저장
     * @param log Log정보
     */
    @RequestMapping(value = "/inputLog", method = RequestMethod.POST)
    public void inputLog(@RequestBody Log log){
        log.setDate(new Date());
        logRepository.save(log);
    }           // inputLog
    /**
     * 현재 로그인한 유저의 이름을 문자로 리턴함
     * @param principal 로그인유저의 정보객체
     * @return 유저의 이름문자 리턴
     */
    @RequestMapping(value = "/getUsername", method = RequestMethod.POST)
    public String getUsername(Principal principal) {
        Member member = memberRepository.findById(principal.getName());
        return member.getName();
    }           // getUsername
    /**
     * 입력받은 값을 바탕으로 DB에 저장되어있는 권한값을 리턴함
     * @param principal
     * @return
     */
    @RequestMapping(value = "/getRank", method = RequestMethod.POST)
    public RankManagement getRank(Principal principal) {
        Member member = memberRepository.findById(principal.getName());
        String state = member.getState();
        String str;
        if(state.equals("3")){
            str = "normal";
        } else if (state.equals("2")){
            str = "admin";
        } else if (state.equals("1")){
            str = "root";
        } else {
            str = "denie";
        }
        return rankManagementRepository.findByName(str);
    }           // getRank



}
