package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.repository.DataInquiry.DataInquiryRepository;
import com.example.tms.repository.MonthlyEmissionsRepository;
import com.example.tms.repository.NotificationStatistics.NotificationDayStatisticsRepository;
import com.example.tms.repository.NotificationList.NotificationListCustomRepository;
import com.example.tms.repository.NotificationStatistics.NotificationMonthStatisticsRepository;
import com.example.tms.repository.NotificationStatistics.NotificationStatisticsCustomRepository;
import com.example.tms.repository.Sensor.SensorCustomRepository;
import com.example.tms.repository.SensorListRepository;
import com.example.tms.service.MemberService;
import com.example.tms.service.RankManagementService;
import lombok.extern.log4j.Log4j2;
import org.bson.types.ObjectId;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
    final MonitoringGroupRepository monitoringGroupRepository;

   public AjaxController(PlaceRepository placeRepository, EmissionsTransitionRepository emissionsTransitionRepository, LogRepository logRepository, SensorCustomRepository sensorCustomRepository, ReferenceValueSettingRepository reference_value_settingRepository, NotificationSettingsRepository notification_settingsRepository, NotificationListCustomRepository notificationListCustomRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, NotificationStatisticsCustomRepository notificationStatisticsCustomRepository, NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, AnnualEmissionsRepository annualEmissionsRepository, EmissionsSettingRepository emissionsSettingRepository, DataInquiryRepository dataInquiryCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, ItemRepository itemRepository, MongoQuary mongoQuary, MemberRepository memberRepository, MemberService memberService, RankManagementRepository rankManagementRepository, RankManagementService rankManagementService, PasswordEncoder passwordEncoder, MonitoringGroupRepository monitoringGroupRepository) {
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
        this.monitoringGroupRepository = monitoringGroupRepository;
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

    @RequestMapping(value = "/getPlaceList2")
    public Object getPlaceList2() {
        List<Place> placeName = placeRepository.findAll();
        JSONArray array = new JSONArray();
        for(int i = 0; i <placeName.size(); i++){
            JSONObject obj = new JSONObject();
            Place place = placeRepository.findByName(placeName.get(i).getName());
            obj.put("name", place.getName());
            obj.put("location", place.getLocation());
            obj.put("admin", place.getAdmin());
            obj.put("tel", place.getTel());
            obj.put("monitoring", place.getMonitoring());
            obj.put("up_time", place.getUp_time());
            array.add(obj);
        }
        return array;
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
     * 측정소명과 센서명으로 중복체크
     *
     * @param place 측정소명
     * @param naming 중복 체크할 센서명  --추가
     * @param naming2 중복 체크할 센서명  -- 수정
     * @return 해당 측정소에 등록된 센서 값
     */
    @RequestMapping(value = "/isNamingEquals")
    public String isNamingEquals(String place,@RequestParam(value = "naming", required = false)String naming,@RequestParam(value = "naming2", required = false)String naming2) {
        Place placeObject = placeRepository.findByName(place);

        if(null == naming2){  //추가
            for (int i =0; i< placeObject.getSensor().size(); i++) {
                if (sensorListRepository.findByTableName(placeObject.getSensor().get(i)+"").getNaming().equals(naming))
                    return "addFalse";
            }
        }
        if(null == naming){  //수정
            for (int i =0; i< placeObject.getSensor().size(); i++) {
                if (sensorListRepository.findByTableName(placeObject.getSensor().get(i)+"").getNaming().equals(naming2))
                    return "editFalse";
            }
        }
        return "true";  //중복없음
    }

    /**
     * 측정소 명으로 센서찾기 -> 센서 테이블명으로 알림설정값 리턴
     *
     * @param placeName 측정소명
     * @return 측정소의 모든 알람설정값 + 센서 네이밍
     */
    @RequestMapping(value = "/getNotificationValue")
    public List getNotificationValue(String placeName) {
        List notificationList = new ArrayList();

        Place place = placeRepository.findByName(placeName);

        for (int i =0 ; i<place.getSensor().size(); i++){
            if(notification_settingsRepository.findByName(place.getSensor().get(i)+"") ==null){
                notificationList.add(sensorListRepository.findByTableName(place.getSensor().get(i)+""));
                //return notificationList;
            }else {
                NotificationSettings notification = notification_settingsRepository.findByName(place.getSensor().get(i) + "");
                notification.setName(notification.getName() + "," + sensorListRepository.findByTableName(place.getSensor().get(i) + "").getNaming());
                notificationList.add(notification);
            }
        }
        return notificationList;
    }

    /**
     * 측정소 명의 센서명으로 모든 상세 기준값 리턴
     * @param place 측정소 이름
     * @return 센서의 법적기준,사내기준,관리기준,모니터링 값
     */

    @RequestMapping(value="/getPlaceSensorValue")
    public Object getPlaceSensorValue(String place) {
        List<String> sensorName = placeRepository.findByName(place).getSensor();
        List valueList = new ArrayList();

        for(int i=0; i<sensorName.size(); i++)
                valueList.add(reference_value_settingRepository.findByName(sensorName.get(i)));

        return valueList;
    }

    /**
     * 해당 측정소명의 모니터링 True 인 센서를 받아와 해당 센서의 최근, 이전, 정보들을 읽어오기 위한 메소드
     * @param place 측정소 이름
     * @return 센서의 최근, 이전, 정보
     */
    @RequestMapping(value="/getPlaceData")
    public JSONArray getPlaceData(String place) {
        List<String> placeName = placeRepository.findByName(place).getSensor();
        JSONArray jsonArray = new JSONArray();
        for(int i=0; i<placeName.size(); i++){
            JSONObject subObj = new JSONObject();
            String sensorName = placeName.get(i);
            boolean monitoring = reference_value_settingRepository.findByName(sensorName).getMonitoring();
            if(monitoring){ //monitoring true
                Sensor recentData = sensorCustomRepository.getSensorRecent(sensorName);
                subObj.put("value", recentData.getValue());
                subObj.put("up_time", recentData.getUp_time());
                subObj.put("status", recentData.isStatus());
                Sensor beforeData = sensorCustomRepository.getSensorBeforeData(sensorName);
                subObj.put("beforeValue", beforeData.getValue());
                ReferenceValueSetting sensorInfo = reference_value_settingRepository.findByName(sensorName);
                subObj.put("naming", sensorInfo.getNaming());
                subObj.put("legalStandard", numberTypeChange(sensorInfo.getLegalStandard()));
                subObj.put("companyStandard", numberTypeChange(sensorInfo.getCompanyStandard()));
                subObj.put("managementStandard", numberTypeChange(sensorInfo.getManagementStandard()));
                subObj.put("name", sensorName);
                jsonArray.add(subObj);
            }
        }
        return jsonArray;
    }

    /**
     * 소수점 아래 존재 .0 일 경우 정수로 바꿔주는 메소드
     * @param number
     * @return 정수형/실수형
     */
    public Object numberTypeChange(float number){
        if(number-Math.round(number) == 0){ //소수점 아래 0일때
            return (int)number;
        }else{
            return Math.round(number*100)/100.0;
        }
    }


    /**
     * 해당 센서의 모터링이 True 인 센서 데이터(최근,이전,기준값 등) Json형태로 리턴하는 메소드
     * @param sensor 센서명
     * @return 센서의 최근, 이전, 정보
     */
    @RequestMapping(value = "/getSensorData")
    public Object getSensorData(String sensor){
        boolean monitoring =  reference_value_settingRepository.findByName(sensor).getMonitoring();
        JSONObject subObj = new JSONObject();
        if(monitoring){
            try{
                Sensor recentData = sensorCustomRepository.getSensorRecent(sensor);
                subObj.put("value", recentData.getValue());
                subObj.put("up_time", recentData.getUp_time());
                subObj.put("status", recentData.isStatus());
            }catch (Exception e){
                return null;
            }
            try {
                Sensor beforeData = sensorCustomRepository.getSensorBeforeData(sensor);
                subObj.put("beforeValue", beforeData.getValue());
            }catch (Exception e){
                subObj.put("beforeValue", 0);
            }
            ReferenceValueSetting sensorInfo = reference_value_settingRepository.findByName(sensor);
            subObj.put("naming", sensorInfo.getNaming());
            subObj.put("legalStandard", numberTypeChange(sensorInfo.getLegalStandard()));
            subObj.put("companyStandard", numberTypeChange(sensorInfo.getCompanyStandard()));
            subObj.put("managementStandard", numberTypeChange(sensorInfo.getManagementStandard()));
            subObj.put("name", sensor);
        }
        return subObj;
    }
    /**
     * 측정소 모니터링 업데이트
     *
     * @param name  측정소명
     * @param check 모니터링 true/false
     */
    @RequestMapping(value = "/MonitoringUpdate")
    public Date MonitoringUpdate(@RequestParam("place") String name, @RequestParam("check") Boolean check, Principal principal) {
        Place place = placeRepository.findByName(name);
        List<String> sensorlist = placeRepository.findByName(name).getSensor();
        ObjectId id = place.get_id();
        Place savePlace = new Place(name, place.getLocation(), place.getAdmin(), place.getTel(), check, new Date(), place.getSensor());
        savePlace.set_id(id);
        if(check == false){
            for(int j = 0; j<sensorlist.size(); j++){
                SensorList sen = sensorListRepository.findByTableName(sensorlist.get(j),"");
                String senname = sen.getNaming();
                if(notification_settingsRepository.findByName(sensorlist.get(j)) != null){
                    notification_settingsRepository.deleteByName(sensorlist.get(j));
                    inputLogSetting( "'"+senname+"'"+" 알림설정 값 삭제","설정",principal);
                }

            }
        }
        placeRepository.save(savePlace);
        return savePlace.getUp_time();
    }

    /**
     * 측정항목 모니터링 변경
     * 현재 모니터링값 반대로 적용
     *
     * @param name      측정소명
     * @param tablename 센서명
     */
    @RequestMapping(value = "/referenceMonitoringUpdate")
    public void referenceMonitoringUpdate(@RequestParam("place") String name, @RequestParam("sensor") String tablename, Principal principal) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setMonitoring(!reference.getMonitoring());
        reference_value_settingRepository.save(reference);
        //측정소 업데이트
        Place place = placeRepository.findByName(name);
        List<String> sensorlist = placeRepository.findByName(name).getSensor();
        int a = 0;
        for (int i = 0; i < sensorlist.size(); i++) {
            Boolean monitoring = reference_value_settingRepository.findByName(sensorlist.get(i)).getMonitoring();
            if (monitoring == false) { //모니터링 갯수 파악
                a++;
            }
        }
        if (a == sensorlist.size()) { //센서 모니터링이 전부 OFF일때
            place.setMonitoring(false);
            for(int j = 0; j<sensorlist.size(); j++){
                SensorList sen = sensorListRepository.findByTableName(sensorlist.get(j),"");
                String senname = sen.getNaming();
                if(notification_settingsRepository.findByName(sensorlist.get(j)) != null){
                    notification_settingsRepository.deleteByName(sensorlist.get(j));
                    inputLogSetting("'"+senname+"'"+" 알림설정 값 삭제","설정",principal);
                }
            }
            inputLogSetting(name+" 모니터링 OFF","설정",principal);
        }

        place.setUp_time(new Date());
        placeRepository.save(place);
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

    @RequestMapping(value = "/getExcessSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getExcessSensor() {
        List<ReferenceValueSetting> monitoringOn = reference_value_settingRepository.findByMonitoringIsTrue();

        JSONObject excess = new JSONObject();
        JSONArray jsonArray = new JSONArray();

        for(ReferenceValueSetting referenceValueSetting : monitoringOn){
            Sensor sensor = sensorCustomRepository.getSensorRecent(referenceValueSetting.getName());
            Date now = new Date();
            long diff = sensor.getUp_time().getTime() - now.getTime();
            long sec = diff / 60000;

            if(sec >= 0 && sec < 5){
                float value = sensor.getValue();
                SensorList sensorInfo = sensorListRepository.findByTableName(referenceValueSetting.getName());;
                JSONObject jsonObject = new JSONObject();

                if( value > referenceValueSetting.getLegalStandard() ){
                    jsonObject.put("classification", "danger");
                }else if( value > referenceValueSetting.getCompanyStandard() ){
                    jsonObject.put("classification", "warning");
                }else if( value > referenceValueSetting.getManagementStandard() ){
                    jsonObject.put("classification", "caution");
                }else{
                    jsonObject.put("classification", "normal");
                }

                jsonObject.put("place", sensorInfo.getPlace());
                jsonObject.put("naming", sensorInfo.getNaming());
                jsonObject.put("value", String.format("%.2f", value));
                jsonObject.put("up_time", sensorInfo.getUpTime());
                jsonArray.add(jsonObject);
                excess.put("excess", jsonArray);
            }
        }

        return excess;
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
     * @param hiddenCode 수정하고 싶은 측정소명
     */
    @RequestMapping(value = "/savePlace")
    public void savePlace(@RequestParam(value = "name") String name, @RequestParam(value = "location") String location, @RequestParam(value = "admin") String admin,
                          @RequestParam(value = "tel") String tel, @RequestParam(value = "hiddenCode") String hiddenCode, Principal principal) {
        Date date = new Date();
        if (hiddenCode == "" || hiddenCode == null) { //추가
            Boolean monitoring = false;
            List sensor = new ArrayList();
            Place newplace = new Place(name, location, admin, tel, monitoring, date, sensor);
            inputLogSetting("측정소 추가 > " + "'"+name+"'","설정",principal);
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
                inputLogSetting("'"+hiddenCode+" - "+sensorlist.get(i).naming+"'"+" 센서 측정소명 '"+name+"' 수정","설정",principal);
                sensorListRepository.save(sensor);
            }

            List<EmissionsStandardSetting> ess = emissionsStandardSettingRepository.findByPlace(hiddenCode);
            for (int i = 0; i < ess.size(); i++) {
                ess.get(i).setPlace(name);
                ess.get(i).setDate(new Date());
                inputLogSetting("'"+hiddenCode+" - "+ess.get(i).getNaming()+"'"+" 배출 관리 기준 측정소명 '"+name+"' 수정","설정",principal);
                emissionsStandardSettingRepository.save(ess.get(i));
            }
            List<AnnualEmissions> ae = annualEmissionsRepository.findByPlace(hiddenCode);
            for (int i = 0; i < ae.size(); i++) {
                ae.get(i).setPlace(name);
                inputLogSetting("'"+hiddenCode+" - "+ae.get(i).getSensorNaming()+"'"+" 배출량 연간 모니터링 측정소명 '"+name+"' 수정","설정",principal);
                annualEmissionsRepository.save(ae.get(i));
            }
            List<EmissionsSetting> es = emissionsSettingRepository.findByPlace(hiddenCode);
            for (int i = 0; i < es.size(); i++) {
                es.get(i).setPlace(name);
                inputLogSetting("'"+hiddenCode+" - "+es.get(i).getSensorNaming()+"'"+" 배출량 모니터링 측정소명 '"+name+"' 수정","설정",principal);
                emissionsSettingRepository.save(es.get(i));
            }
            List<EmissionsTransition> et = emissionsTransitionRepository.findByPlaceName(hiddenCode);
            for (int i = 0; i < et.size(); i++) {
                et.get(i).setPlaceName(name);
                inputLogSetting("'"+hiddenCode+" - "+et.get(i).getSensorName()+"'"+" 분기별 배출량 측정소명 '"+name+"' 수정","설정",principal);
                emissionsTransitionRepository.save(et.get(i));
            }
            inputLogSetting("'"+hiddenCode+"' > '"+name+"' 측정소명 수정","설정",principal);

            List<MonitoringGroup> group = monitoringGroupRepository.findByMonitoringPlaceIsIn(hiddenCode);
            if(group != null) {
                for (int i=0; i<group.size(); i++){
                    List<String> groupPlaceList = group.get(i).getMonitoringPlace();
                    int index = groupPlaceList.indexOf(hiddenCode);
                    groupPlaceList.set(index, name);
                    group.get(i).setMonitoringPlace(groupPlaceList);
                    monitoringGroupRepository.save(group.get(i));
                }
                inputLogSetting("'" + hiddenCode + "' > '" + name + "' 최고 관리자 그룹의 모니터링 측정소 수정", "설정", principal);
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
    public void removePlace(@RequestParam(value = "placeList[]") List<String> placeList, boolean flag, Principal principal) {

        for (int i = 0; i < placeList.size(); i++) {
            if (flag) {
                removePlaceRemoveSensor(placeList.get(i), principal);       //센서 포함 삭제
            } else {
                removePlaceChangeSensor(placeList.get(i), principal);       //측정소만 삭제
            }
            //삭제될 측정소 그룹에서 삭제
            List<MonitoringGroup> group = monitoringGroupRepository.findByMonitoringPlaceIsIn(placeList.get(i));

            for (int k = 0; k<group.size(); k++){
                List<String> groupPlaceList = group.get(k).getMonitoringPlace();
                int index = groupPlaceList.indexOf(placeList.get(i));
                groupPlaceList.remove(index);
                group.get(k).setMonitoringPlace(groupPlaceList);
                monitoringGroupRepository.save(group.get(k));
            }
        }
    }

    /**
     * 측정소만 삭제 , 센서는 측정소명 ""으로 변경, 상세설정 비활성화
     *
     * @param place 측정소명
     */
    public void removePlaceChangeSensor(String place, Principal principal) {
        Place placeInfo = placeRepository.findByName(place);

        List<String> sensor = placeInfo.getSensor();
        for (int i = 0; i < sensor.size(); i++) {
            SensorList sen = sensorListRepository.findByTableName(sensor.get(i), "");
            String sensorname = sen.getNaming();
            //알림설정 False 설정
            NotificationSettings no = notification_settingsRepository.findByName(sensor.get(i));
            if (no != null) {
                no.setStatus(false);
                inputLogSetting("'"+sensorname+"'"+" 알림설정 초기화" ,"설정",principal);
                notification_settingsRepository.save(no);
            }

            //배출량 관리 - 모니터링 대상 False 설정
            EmissionsSetting em = emissionsSettingRepository.findBySensor(sensor.get(i));
            if (em != null) {
                em.setStatus(false);
                em.setPlace("");
                inputLogSetting("'"+sensorname+"'"+" 배출량 모니터링 OFF" ,"설정",principal);
                emissionsSettingRepository.save(em);
            }

            //배출량 관리 - 연간 모니터링 대상 False 설정
            AnnualEmissions aem = annualEmissionsRepository.findBySensor(sensor.get(i));
            if (aem != null) {
                aem.setStatus(false);
                aem.setPlace("");
                inputLogSetting("'"+sensorname+"'"+" 배출량 연간 모니터링 OFF","설정",principal);
                annualEmissionsRepository.save(aem);
            }

            //센서 관리 - 측정소 값 삭제
            SensorList sl = sensorListRepository.findByTableName(sensor.get(i), "");
            if (sl != null) {
                sl.setPlace("");
                inputLogSetting("'"+sensorname+"'"+" 센서 등록 측정소 '"+place +"' 삭제","설정",principal);
                sensorListRepository.save(sl);
            }

            //상세설정 모니터링 값 False
            ReferenceValueSetting rv = reference_value_settingRepository.findByName(sensor.get(i));
            if (rv != null) {
                rv.setMonitoring(false);
                inputLogSetting("'"+sensorname+"'"+" 모니터링 OFF","설정",principal);
                reference_value_settingRepository.save(rv);
            }

            //배출 관리 기준 측정소값 삭제
            EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(sensor.get(i));
            if (ess != null) {
                ess.setPlace("");
                ess.setDate(new Date());
                inputLogSetting("'"+sensorname+"'"+" 배출 관리 기준 등록 측정소 '"+place +"' 삭제" ,"설정",principal);
                emissionsStandardSettingRepository.save(ess);
            }

            //분기별 배출량 측정소 변경
            List<EmissionsTransition> et = emissionsTransitionRepository.findByTableName(sensor.get(i));
            if (et != null) {
                for (int k=0; k<et.size(); k++){
                    et.get(k).setPlaceName("");
                    emissionsTransitionRepository.save(et.get(k));
                }
                inputLogSetting("'"+sensorname+"'"+" 분기별 배출량 등록 측정소 '"+place +"' 삭제" ,"설정",principal);
            }

        }
        //측정소 삭제
        inputLogSetting("'"+place+"' 삭제" ,"설정",principal);
        placeRepository.deleteByName(place);
    }

    /**
     * 측정소와 센서,상세설정값 동시에 삭제
     *
     * @param place 측정소명
     */
    public void removePlaceRemoveSensor(String place,Principal principal) {
        Place placeInfo = placeRepository.findByName(place);

        //측정소 삭제
        placeRepository.deleteByName(place);
        inputLogSetting("'"+place+"' 삭제" ,"설정",principal);

        List<String> sensor = placeInfo.getSensor();
        for (int i = 0; i < sensor.size(); i++) {
            SensorList sen = sensorListRepository.findByTableName(sensor.get(i),"");
            String sensorname = sen.getNaming();
            reference_value_settingRepository.deleteByName(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 상세설정 값 삭제" ,"설정",principal);

            notification_settingsRepository.deleteByName(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 알림설정 값 삭제" ,"설정",principal);

            emissionsSettingRepository.deleteBySensor(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 배출량 모니터링 대상 삭제" ,"설정",principal);

            annualEmissionsRepository.deleteBySensor(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 배출량 연간 모니터링 대상 삭제" ,"설정",principal);

            emissionsStandardSettingRepository.deleteByTableName(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 배출 관리 기준 삭제" ,"설정",principal);

            emissionsTransitionRepository.deleteByTableName(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 분기별 배출량 정보 삭제" ,"설정",principal);

            sensorListRepository.deleteByTableName(sensor.get(i));
            inputLogSetting("'"+sensorname+"'"+" 센서 삭제" ,"설정",principal);
        }
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
    public SensorList getSensorManagementId(@RequestParam("name") String tablename) {
        return sensorListRepository.findByTableName(tablename);
    }

    /**
     * 테이블 명으로 센서 가져오기
     *
     * @param place 측정소명
     * @return 센서의 네이밍 리스트
     */
    @RequestMapping(value = "/findSensorList")
    public List findSensorCategoryList(@RequestParam("place") String place) {
        List<SensorList> list = sensorListRepository.findByPlace(place);
        return list;
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
     * 측정소의 모든 센서 최근 값 조회
     * @param place 측정소명
     * @return 모든 센서의 최근 값
     */
    @RequestMapping(value = "/getSensorRecent2")
    public Object getSensorRecent2(@RequestParam("place") String place) {
        List<String> placeName = placeRepository.findByName(place).getSensor();
        JSONArray jsonArray = new JSONArray();
        for(int i=0; i<placeName.size(); i++){
            JSONObject subObj = new JSONObject();
            boolean monitoring = reference_value_settingRepository.findByName(placeName.get(i)).getMonitoring();
            if(monitoring) { //monitoring true
                try{
                    Sensor recentData = sensorCustomRepository.getSensorRecent(placeName.get(i));
                    subObj.put("value", recentData.getValue());
                    subObj.put("up_time", recentData.getUp_time());
                    subObj.put("status", recentData.isStatus());
                }catch (Exception e){
                    return null;
                }
                jsonArray.add(subObj);
            }
        }
        return jsonArray;
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
     * @param name      센서명
     * @param naming    센서 네이밍
     */
    public void saveReference(String placename, String name, String naming,Principal principal) {
        inputLogSetting("'"+placename + " - " + naming+"'" + " 센서 관리 기준 값 설정", "설정", principal);

        if (placeRepository.findBySensorIsIn(name) != null) { //기존 센서가 존재
            //place 업데이트 시간 수정
            placeUpTime(placename);
        } else { //최초 입력
            Place placesensor = placeRepository.findByName(placename);
            List<String> sensor = placesensor.getSensor();
            sensor.add(name);
            placesensor.setSensor(sensor);
            placeRepository.save(placesensor);
            inputLogSetting("'"+placename + " - " + naming+"'" + " 센서 추가", "설정", principal);

        }
        float legal = 999999.0f;
        float company = 999999.0f;
        float management = 999999.0f;
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
     * 일별 / 월별  알림 현황 (기준초과 카운팅) 저장
     * notification_day_statistics(일) , notification_month_statistics(월)
     */
    /*
    @RequestMapping(value = "saveNS")
    public ArrayList saveNS() {
        ArrayList al = new ArrayList();
        LocalDate nowDate = LocalDate.now(); //현재시간
        int getYear = nowDate.getYear();
        int getMonth = nowDate.getMonthValue();
        int getDay = nowDate.getDayOfMonth();
        LocalDate getYesterday = nowDate.minusDays(1);
        LocalDate getLastMonth = nowDate.minusMonths(1);

        *//**
         * 일별 알림 현황 저장 ( 1월1일 ~ 전날(yesterday))
         *//*
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
                    int[] arr = new int[3];
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
        *//**
         * 월별 알림 현황 저장 (1월 ~ 이번달)
         *//*
        for (int m = 1; m <= getMonth; m++) {
            LocalDate from_date = LocalDate.of(getYear, m, 1);
            LocalDate to_date = LocalDate.of(getYear, m, from_date.lengthOfMonth());
            String date = String.valueOf(from_date).substring(0, 7);
            notificationMonthStatisticsRepository.deleteByMonth(date); //데이터가 존재할 경우 삭제
            try {
                int[] arr = new int[3];
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
    */
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
     * @return EmissionsStandardSetting.FindALL
     */
    @RequestMapping(value = "/saveEmissionsStandard")
    public List saveEmissionsStandard(@RequestParam(value = "standard") int standard, @RequestParam(value = "hiddenTableName", required = false) String hiddenTableName,
                                      @RequestParam(value = "percent") int percent, @RequestParam(value = "formula") String formula, Principal principal) {
        EmissionsStandardSetting setting = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenTableName);

        setting.setEmissionsStandard(standard);
        setting.setDensityStandard(percent);
        setting.setFormula(formula);
        setting.setDate(new Date());
        emissionsStandardSettingRepository.save(setting);

        inputLogSetting("'"+setting.getPlace()+" - "+setting.getNaming()+"'"+" 센서 연간 배출 허용 기준 변경 ","설정",principal);

        List<EmissionsStandardSetting> standardList = emissionsStandardSettingRepository.findAll();
        return standardList;
    }

    /**
     * 로그 셋팅해서 입력하는 메소드
     * @param content 내용
     * @param type    타입
     * @param principal id
     */
    public void inputLogSetting(String content,String type,Principal principal){
        inputLog( new Log(principal.getName(),content,type) );
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
     * @param hiddenCode     수정시 사용할 테이블 명
     */
    @RequestMapping(value = "/saveSensor")
    public void saveSensor(@RequestParam(value = "managementId", required = false) String managementId,
                           @RequestParam(value = "classification", required = false) String classification,
                           @RequestParam(value = "naming", required = false) String naming,
                           @RequestParam(value = "place") String place,
                           @RequestParam(value = "naming2", required = false) String naming2,
                           @RequestParam(value = "tableName", required = false) String tableName,
                           @RequestParam(value = "hiddenCode", required = false) String hiddenCode,
                           @RequestParam(value = "isValueDelete", required = false) String isValueDelete,Principal principal) {

        SensorList sensor;
        //hidden 값이 있는지로 추가와 수정을 판별
        //생성
        if (hiddenCode == null) {

            sensor = new SensorList(classification, naming, managementId, tableName, new Date(), place, true);

            //연간 배출량 누적 모니터랑 대상 && 배출량 추이 모니터링 대상   설정에도 추가합니다.
            AnnualEmissions aEmissions = new AnnualEmissions(place, tableName, naming, 0, false, new Date());
            annualEmissionsRepository.save(aEmissions);
            inputLogSetting("'"+place + " - " + naming +"'"+ " 센서 연간 배출량 모니터링 대상 추가", "설정", principal);

            //배출량 추이 모니터링 대상 설정 생성
            EmissionsSetting emissions = new EmissionsSetting(place, tableName, naming, false);
            emissionsSettingRepository.save(emissions);
            inputLogSetting("'"+place + " - " + naming+"'" + " 센서 배출량 추이 모니터링 대상 추가", "설정", principal);

            //연간 배출 허용 기준 생성
            EmissionsStandardSetting ess = new EmissionsStandardSetting(place,naming,0,0,tableName,"",new Date());
            emissionsStandardSettingRepository.save(ess);
            inputLogSetting("'"+place + " - " + naming+"'" + " 센서 연간 배출 허용 기준 추가", "설정", principal);

            saveReference(place, tableName, naming,principal); //상세설정 항목 추가
            inputLogSetting( "'"+sensor.getNaming()+"'" + " 센서 추가", "설정", principal);

            /*
            //올해, 작년 분기별 배출데이터 생성
            int thisYear = Calendar.getInstance().get(Calendar.YEAR);
            EmissionsTransition thisYearTransition = new EmissionsTransition(
                    tableName, place, naming, thisYear, 0, 0, 0, 0, 0, new Date());
            EmissionsTransition lastYearTransition = new EmissionsTransition(
                    tableName, place, naming, thisYear-1, 0, 0, 0, 0, 0, new Date());
            emissionsTransitionRepository.save(thisYearTransition);
            emissionsTransitionRepository.save(lastYearTransition);

            //월별 데이터 생성
            if(monthlyEmissionsRepository.findBySensorAndYear(tableName, thisYear) == null) {
                MonthlyEmissions me = new MonthlyEmissions();
                me.setSensor(tableName);
                me.setYear(thisYear);
                me.setUpdateTime(new Date());
                monthlyEmissionsRepository.save(me);
            }
            */


        } else { //수정
            sensor = sensorListRepository.findByTableName(hiddenCode, "");
            String oldPlace = sensor.getPlace();
            String oldNaming = sensor.getNaming();
            sensor.setPlace(place);
            sensor.setNaming(naming2);
            sensor.setUpTime(new Date());

            if(oldPlace.equals("")) oldPlace = "측정소 없음";

            //센서관련 법적기준,사내기준,관리기준값 사용자 동의하에 초기화
            if (isValueDelete.equals("delete")) {
                ReferenceValueSetting reference = reference_value_settingRepository.findByName(hiddenCode);
                float legal = 999999.0f;
                float management = 999999.0f;
                float company = 999999.0f;
                reference.setLegalStandard(legal);
                reference.setNaming(naming2);
                reference.setCompanyStandard(company);
                reference.setManagementStandard(management);
                reference.setMonitoring(false);
                reference_value_settingRepository.save(reference);
                inputLogSetting("'"+oldPlace + " - " + sensor.getNaming()+"'" + " 관리 기준 초기화", "설정", principal);

            }

            //항목명 변경
            if(!oldNaming.equals(naming2)){

                //연간 배출 모니터링 대상 수정
                AnnualEmissions aemis = annualEmissionsRepository.findBySensor(hiddenCode);
                aemis.setSensorNaming(naming2);
                aemis.setStatus(false);
                annualEmissionsRepository.save(aemis);
                inputLogSetting("'"+oldPlace + " - " + sensor.getNaming()+"'" + " 센서 연간 배출 모니터링 대상 항목명 수정", "설정", principal);

                //배출 모니터링 대상 수정
                EmissionsSetting emis = emissionsSettingRepository.findBySensor(hiddenCode);
                emis.setSensorNaming(naming2);
                emis.setStatus(false);
                emissionsSettingRepository.save(emis);
                inputLogSetting("'"+oldPlace + " - " + sensor.getNaming()+"'" + " 센서 배출량 추이 모니터링 대상 항목명 수정", "설정", principal);


                //배출 관리 기준 수정
                EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenCode);
                ess.setNaming(naming2);
                ess.setDate(new Date());
                emissionsStandardSettingRepository.save(ess);
                inputLogSetting("'"+oldPlace + " - " + sensor.getNaming()+"'" + " 센서 연간 배출 허용 기준 항목명 수정", "설정", principal);


                //분기별 배출량 데이터 수정
                List<EmissionsTransition> et = emissionsTransitionRepository.findByTableName(hiddenCode);
                if (et != null) {
                    for (int i = 0; i<et.size(); i++) {
                        et.get(i).setSensorName(naming2);
                        emissionsTransitionRepository.save(et.get(i));
                    }
                    inputLogSetting("'"+et.get(0).getPlaceName() + " - " + sensor.getNaming()+"'" + " 센서 분기별 배출량 항목명 수정", "설정", principal);
                }

                inputLogSetting("'"+oldNaming+"' 센서의 항목명 "+"'"+oldNaming+"'" + " > " + "'"+naming2+"'" + " 수정 ", "설정", principal);
                ReferenceValueSetting reference = reference_value_settingRepository.findByName(hiddenCode);
                reference.setNaming(naming2);
                reference_value_settingRepository.save(reference);

            }

            //측정소 변경
            if(!oldPlace.equals(place)){
                inputLogSetting("'"+oldPlace + " - " + oldNaming+"'" + " 센서 삭제 ", "설정", principal);

                //연간 배출 모니터링 대상 수정
                AnnualEmissions aemis = annualEmissionsRepository.findBySensor(hiddenCode);
                aemis.setPlace(place);
                aemis.setStatus(false);
                annualEmissionsRepository.save(aemis);
                inputLogSetting("'"+oldPlace + " - " + oldNaming+"'" + " 센서 연간 배출 모니터링 대상 측정소명 수정", "설정", principal);

                //배출 모니터링 대상 수정
                EmissionsSetting emis = emissionsSettingRepository.findBySensor(hiddenCode);
                emis.setPlace(place);
                emis.setStatus(false);
                emissionsSettingRepository.save(emis);
                inputLogSetting("'"+oldPlace + " - " + oldNaming+"'" + " 센서 배출량 추이 모니터링 대상 측정소명 수정", "설정", principal);

                //배출 관리 기준 수정
                EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenCode);
                ess.setPlace(place);
                ess.setDate(new Date());
                emissionsStandardSettingRepository.save(ess);
                inputLogSetting("'"+oldPlace + " - " + oldNaming+"'" + " 센서 연간 배출 허용 기준 수정", "설정", principal);


                //분기별 배출량 데이터 수정
                List<EmissionsTransition> et = emissionsTransitionRepository.findByTableName(hiddenCode);
                if (et != null) {
                    for (int i = 0; i<et.size(); i++) {
                        et.get(i).setPlaceName(place);
                        emissionsTransitionRepository.save(et.get(i));
                    }
                    inputLogSetting("'"+oldPlace + " - " +oldNaming+"'" + " 센서 분기별 배출량 측정소명 수정", "설정", principal);
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

                //측정소 센서 추가 및 시간 업데이트
                Place placeadd = placeRepository.findByName(place); //측정소 정보
                placeadd.getSensor().add(hiddenCode);
                placeadd.setUp_time(new Date());
                placeRepository.save(placeadd);

                //센서 관련 notification 값 제거
                notification_settingsRepository.deleteByName(hiddenCode);
                inputLogSetting("'"+oldPlace + " - " + oldNaming+"'" + " 센서 알림설정 값 삭제", "설정", principal);
                inputLogSetting("'"+place + " - " + oldNaming+"'" + " 센서 등록", "설정", principal);
                inputLogSetting("'"+oldNaming+"'"+" 센서의 측정소명 "+"'"+oldPlace+"'" + " > " + "'"+place+"'" + " 수정 ", "설정", principal);
            }

            //수정된 이전 측정소 모니터링 체크후 False or True
            if(!oldPlace.equals("측정소 없음")) {
                //place 모니터링 체크
                Place placeCheck = placeRepository.findByName(oldPlace);

                List sensorList = placeCheck.getSensor();
                boolean flag = false;

                for (int i = 0; i < sensorList.size(); i++) {
                    if (reference_value_settingRepository.findByName((String) sensorList.get(i)).getMonitoring() == true){
                        flag = true;
                        break;
                    }
                }
                placeCheck.setMonitoring(flag);
                placeRepository.save(placeCheck);
            }


        }
        sensorListRepository.save(sensor);
    }

    /**
     * 센서 상세설정값 삭제, 센서 삭제
     *
     * @param tableName 테이블 명
     */
    @RequestMapping(value = "/deleteSensor")
    public void deleteSensor(String tableName,Principal principal) {
        //배출량 관리 기준 삭제
        EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(tableName);
        emissionsStandardSettingRepository.deleteByTableName(tableName);
        if(ess.getPlace().equals(""))ess.setPlace("측정소 없음");
        inputLogSetting("'"+ess.getPlace() + " - " + ess.getNaming()+"'" + " 연간 허용 배출 기준 삭제", "설정", principal);

        //상세설정 값 삭제
            reference_value_settingRepository.deleteByName(tableName);
            inputLogSetting("'"+ess.getPlace() + " - " + ess.getNaming()+"'" + " 관리 기준 값 삭제", "설정", principal);

        //분기별 배출량 정보 삭제
        if (emissionsTransitionRepository.findByTableName(tableName) != null) {
            emissionsTransitionRepository.deleteByTableName(tableName);
            inputLogSetting("'"+ess.getPlace() + " - " + ess.getNaming()+"'" + " 분기별 배출량 삭제", "설정", principal);
        }

        //알림설정값 삭제
        if (notification_settingsRepository.findByName(tableName) != null) {
            notification_settingsRepository.deleteByName(tableName);
            inputLogSetting("'"+ess.getPlace() + " - " + ess.getNaming()+"'" + " 알림 설정값 삭제", "설정", principal);
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
        inputLogSetting("'"+ess.getPlace() + " - "+ess.getNaming()+"'"+" 배출량 추이 모니터링 대상 삭제", "설정", principal);
        //배출량 관리 - 연간 모니터링 대상 삭제
        annualEmissionsRepository.deleteBySensor(tableName);
        inputLogSetting("'"+ess.getPlace() + " - "+ess.getNaming()+"'"+" 연간 배출량 모니터링 대상 삭제", "설정", principal);

        //센서 삭제
        SensorList sensor = sensorListRepository.findByTableName(tableName, "");
        sensorListRepository.delete(sensor);
        inputLogSetting("'"+ess.getPlace()+" - "+ess.getNaming()+"'"+" 센서 삭제", "설정", principal);
        inputLogSetting("'"+ess.getNaming()+"'"+" 센서 삭제", "설정", principal);


    }

    /**
     * 센서와 년도를 넣고 월별 데이터를 추출
     *
     * @param sensor 센서명
     * @param thisYear   현재년도
     * @return 올해,작년 월별 데이터
     */
    @RequestMapping(value = "/getStatisticsData", method = RequestMethod.POST)
    public List getStatisticsData(String sensor, int thisYear) {

        MonthlyEmissions thisMe = monthlyEmissionsRepository.findBySensorAndYear(sensor, thisYear);
        MonthlyEmissions prevMe = monthlyEmissionsRepository.findBySensorAndYear(sensor, thisYear-1);
        List monthlyList = new ArrayList();

        monthlyList.add(thisMe);
        monthlyList.add(prevMe);

        return monthlyList;
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
     * 배출량 모니터링 상태값을 변경
     *
     * @param sensor       상태값 변경할 센서
     * @param isCollection 배출량 추이 모니터링 <->연간 배출량 누적 모니터링   판별할 데이터
     */
    @RequestMapping("emissionsState")
    public void emissionsState(String sensor, boolean isCollection,Principal principal) {

        if (isCollection) {   //배출량 설정
            EmissionsSetting target = emissionsSettingRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            emissionsSettingRepository.save(target);
            String onOff = (target.isStatus()?"ON":"OFF");
            inputLogSetting("'"+target.getPlace() + " - " + target.getSensorNaming()+"'" + " 센서 배출량 추이 모니터링 대상 "+onOff, "설정", principal);

        } else {     //연간 배출량 설정
            AnnualEmissions target = annualEmissionsRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            annualEmissionsRepository.save(target);
            String onOff = (target.isStatus()?"ON":"OFF");
            inputLogSetting("'"+target.getPlace() + " - " + target.getSensorNaming()+"'" + " 센서 연간 배출량 누적 모니터링 대상 "+onOff, "설정", principal);
        }
    }

    /**
     * 회원가입
     *
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
            groupChange(member.getId(), member.getMonitoringGroup());
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
        memberService.updateLog(member);
        groupChange(member.getId(), member.getMonitoringGroup());
        return "success";
    }
    @RequestMapping(value = "/memberGroupUpdate")
    public String memberGroupUpdate(String id, String monitoringGroup) {
        memberService.updateMemberGroup(id, monitoringGroup);
        memberService.updateGroupLog(id);
        groupChange(id, monitoringGroup);
        return "success";
    }

    public void groupChange(String id, String monitoringGroup){
        MonitoringGroup memberRemove = monitoringGroupRepository.findByGroupMemberIsIn(id);
        if(memberRemove != null){
            memberRemove.getGroupMember().remove(id);
            monitoringGroupRepository.save(memberRemove);
        }
        MonitoringGroup group = monitoringGroupRepository.findByGroupName(monitoringGroup);
        List<String> member = null;
        if(group.getGroupMember() != null) {
            member = group.getGroupMember();
            member.add(id);
        }else{
            member = new ArrayList();
            member.add(id);
        }
        group.setGroupMember(member);
        monitoringGroupRepository.save(group);
    }

    /**
     * 회원탈퇴
     *
     * @param id 탈퇴할 회원의 ID
     * @return 회원탈퇴 성공여부
     */
    @RequestMapping(value = "/memberOut")
    public String memberOut(String id, String password) {
        Member member = memberRepository.findById(id);
        if (passwordEncoder.matches(password, member.getPassword())) {
            memberService.deleteById(id);
            MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(id);
            if(group != null){
               int memberIndex = group.getGroupMember().indexOf(id);
               group.getGroupMember().remove(memberIndex);
               monitoringGroupRepository.save(group);
            }
            return "success";
        } else {
            return "fail";
        }
    }

    /**
     * 현재 비밀번호 체크
     *
     * @param id
     * @param password
     * @return
     */
    @RequestMapping(value = "/nowPasswordCheck")
    public String nowPasswordCheck(String id, String password) {
        Member newMember = memberRepository.findById(id);
        if (!passwordEncoder.matches(password, newMember.getPassword())) {
            return "failed";
        } else {
            return "success";
        }
    }

    @RequestMapping(value = "/getMonitoringGroup")
    public List<MonitoringGroup> getMonitoringGroup() {
        return monitoringGroupRepository.findAll();

    }

    /**
     * 로그인시 입력받은 사용자 정보를 검사
     *
     * @param member   입력받은 사용자정보 객체
     * @param response 뷰로 문자열을 전달하기위한 변수
     * @throws Exception 예외처리
     */
    @RequestMapping(value = "/loginCheck", method = RequestMethod.POST)
    public void loginCheck(Member member, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        if (!memberRepository.existsById(member.getId())) {
            out.print("id");
        } else if (!passwordEncoder.matches(member.getPassword(), memberRepository.findById(member.getId()).getPassword())) {
            out.print("password");
        } else if (memberRepository.findById(member.getId()).getState().equals("5")) {
            out.print("denie");
        } else if (memberRepository.findById(member.getId()).getState().equals("4")) {
            out.print("waiting");
        } else {
            Member newMember = memberRepository.findById(member.getId());
            Date time = new Date();
            newMember.setLastLogin(time);
            memberRepository.save(newMember);
        }
    }

    /**
     * 회원가입신청 한 유저의 승낙 여부를 결정
     *
     * @param id      가입신청한유저의 id
     * @param iNumber 0 - 거부 / 1 - 승인 을나타냄
     * @return 안내메시지를 리턴
     */
    @RequestMapping(value = "/signUp", method = RequestMethod.POST)
    public String memberSignUp(String id, String iNumber,String state) {
        String msg = "";
        Member newMember = memberRepository.findById(id);
        if (iNumber.equals("0")) {
            newMember.setState("5");
            msg = "가입 거절 되었습니다.";
        } else {
            newMember.setState(state);
            Date time = new Date();
            newMember.setJoined(time);
            msg = "가입 승인 되었습니다.";
        }
        memberRepository.save(newMember);
        return msg;
    }
    /**
     * 입력받은 값으로 유저의 등급을 결정
     *
     * @param id    등급을 결정할 유저의 id
     * @param value 등급값
     * @return 안내메시지 리턴
     */
    @RequestMapping(value = "/gaveRank", method = RequestMethod.POST)
    public String gaveRank(String id, String value) {
        Member newMember = memberRepository.findById(id);

        //회원 등급 변동에 따른 그룹 수정
        //최고관리자를 변경하고, 해당 멤버가 default그룹이 아닐떄 default로 변경
        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(id);
        if (value.equals("1") && group.getGroupNum() != 0) {
            newMember.setMonitoringGroup("ALL");
            List memberList = group.getGroupMember();
            for (int i=0; i<memberList.size(); i++){
                if(memberList.get(i).equals(id))
                    memberList.remove(i);
            }
            group.setGroupMember(memberList);
            monitoringGroupRepository.save(group);

            MonitoringGroup allGroup = monitoringGroupRepository.findByGroupNum(0);
            List allGroupMember = allGroup.getGroupMember();
            allGroupMember.add(id);
            allGroup.setGroupMember(allGroupMember);
            monitoringGroupRepository.save(allGroup);
        }

        newMember.setState(value);
        memberRepository.save(newMember);
        return newMember.getName()+" 회원의 권한이 변경되었습니다.";
    }

    /**
     * 입력받은 값으로 유저의 비밀번호를 초기화
     *
     * @param id 초기화할 유저의 id
     * @return 안내메시지와 임시비밀번호 메시지 리턴
     */
    @RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
    public String resetPassword(String id) {
        Member newMember = memberRepository.findById(id);
        String uuid = (UUID.randomUUID().toString().replaceAll("-", "")).substring(0, 10);
        String encodedPwd = passwordEncoder.encode(uuid);
        newMember.setPassword(encodedPwd);
        memberRepository.save(newMember);
        return "임시비밀번호 : " + uuid;
    }

    /**
     * 입력받은 값으로 유저를 추방
     * @param id 제명할 유저의 id
     * @return 안내메시지 리턴
     */
    @RequestMapping(value = "/kickMember", method = RequestMethod.POST)
    public String kickMember(String id) {
        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(id);
        if(group != null){
            for (int i = 0; i<group.getGroupMember().size(); i++){
                if(group.getGroupMember().get(i).equals(id))
                    group.getGroupMember().remove(i);
            }
            monitoringGroupRepository.save(group);
        }
        memberRepository.deleteById(id);
        logRepository.deleteById(id);
        return "제명처리 되었습니다.";
    }

    /**
     * 변경한 권한관리 값들을 저장
     * @param rankManagement 변경한 값들을 담고있는 객체
     * @throws Exception 예외처리
     * @return
     */
    @RequestMapping(value = "/rankSettingSave", method = RequestMethod.POST)
    public List<String> rankSettingSave(@RequestBody RankManagement rankManagement) throws Exception {
        RankManagement newRankManagement = rankManagementRepository.findByName(rankManagement.getName());
        List<String> stringList = new ArrayList<>();
        stringList.add((rankManagement.isDashboard() == newRankManagement.isDashboard()) ? "" : (rankManagement.isDashboard()) ? "대시보드 메뉴열람 권한부여  " : "대시보드 메뉴열람 권한해제  ") ;
        stringList.add((rankManagement.isAlarm() == newRankManagement.isAlarm()) ? "" : (rankManagement.isAlarm()) ? "알림 메뉴열람 권한부여  " : "알림 메뉴열람 권한해제  ");
        stringList.add((rankManagement.isMonitoring() == newRankManagement.isMonitoring()) ? "" : (rankManagement.isMonitoring()) ? "모니터링 메뉴열람 권한부여  " : "모니터링 메뉴열람 권한해제  ");
        stringList.add((rankManagement.isStatistics() == newRankManagement.isStatistics()) ? "" : (rankManagement.isStatistics()) ? "분석및통계 메뉴열람 권한부여  " : "분석및통계 메뉴열람 권한해제  ");
        stringList.add((rankManagement.isSetting() == newRankManagement.isSetting()) ? "" : (rankManagement.isSetting()) ? "환경설정 메뉴열람 권한부여" : "환경설정 메뉴열람 권한해제");
        newRankManagement.setDashboard(rankManagement.isDashboard());
        newRankManagement.setAlarm(rankManagement.isAlarm());
        newRankManagement.setMonitoring(rankManagement.isMonitoring());
        newRankManagement.setStatistics(rankManagement.isStatistics());
        newRankManagement.setSetting(rankManagement.isSetting());
        rankManagementRepository.save(newRankManagement);
        return stringList;
    }

    /**
     * 로그정보를 날짜추가후 DB에 저장
     *
     * @param log Log정보
     */
    @RequestMapping(value = "/inputLog", method = RequestMethod.POST)
    public void inputLog(@RequestBody Log log) {
        log.setDate(new Date());
        logRepository.save(log);
    }

    /**
     * 현재 로그인한 유저의 이름을 문자로 리턴함
     *
     * @param principal 로그인유저의 정보객체
     * @return 유저의 이름문자 리턴
     */
    @RequestMapping(value = "/getUsername", method = RequestMethod.POST)
    public String getUsername(Principal principal) {
        Member member = memberRepository.findById(principal.getName());
        return member.getName();
    }

    /**
     * 테이블명으로 배출기준값 리턴
     * @param tableName 테이블명
     * @return 배출허용 기준치
     */
    @RequestMapping(value = "/getStandardValue", method = RequestMethod.POST)
    public EmissionsStandardSetting getStandardValue(String tableName) {
        return emissionsStandardSettingRepository.findByTableNameIsIn(tableName);
    }

    /**
     * 입력받은 값을 바탕으로 DB에 저장되어있는 권한값을 리턴함
     *
     * @param principal
     * @return
     */
    @RequestMapping(value = "/getRank", method = RequestMethod.POST)
    public RankManagement getRank(Principal principal) {
        Member member = memberRepository.findById(principal.getName());
        String state = member.getState();
        String str;
        if (state.equals("3")) {
            str = "normal";
        } else if (state.equals("2")) {
            str = "admin";
        } else if (state.equals("1")) {
            str = "root";
        } else {
            str = "denie";
        }
        return rankManagementRepository.findByName(str);
    }

    /**
     * 페이징 쿼리로 반환되는 로그 데이터
     * @param pageNo 몇페이지 인지
     * @param id 로그아이디
     * @param searchKey 검색키
     * @param searchType 검색타입
     * @return
     */
    @RequestMapping(value = "/logPagination", method = RequestMethod.POST)
    public Object logPagination(int pageNo, String id, String searchKey, String searchType) {
        if(searchKey.equals("")) searchKey = null;
        return mongoQuary.pagination(pageNo, id, searchKey, searchType);
    }


    /**
     * 검색어로 반환되는 로그데이터 Count
     * @param id 로그를 구별할 id
     * @param searchKey 로그 구별할 검색어
     * @param searchType 로그 구별할 검색타입
     * @return 로그 카운트
     */
    @RequestMapping(value = "/getLogCountBySearchKey", method = RequestMethod.POST)
    public long getLogCountBySearchKey(String id,String searchKey,String searchType) {
        if(searchType.equals("type")){
            return logRepository.countByIdAndType(id, searchKey);

        }else if(searchType.equals("content")){
            return logRepository.countByIdAndContentLike(id, searchKey);

        }else if(searchType.equals("date")){
            return mongoQuary.getDateCount(id, searchKey);

        }
        return 0;
    }

    /**
     * 그룹 저장, 수정
     * @param name 그룹명
     * @param memList 그룹에 포함될 멤버
     * @param placeList 그룹에 포함될 측정소
     * @param flag 저장, 수정 식별키
     * @param groupNum 수정시 그룹을 식별할 키
     */
    @RequestMapping(value = "/saveGroup", method = RequestMethod.POST)
    public String saveGroup(String name, @RequestParam(value="memList[]", required = false)List<String> memList,
                            @RequestParam(value="placeList[]",required = false)List<String> placeList, String flag,
                            @RequestParam(value = "groupNum",required = false)int groupNum) {
        MonitoringGroup group = null;

        //중복 이름 리턴 fail
        if(monitoringGroupRepository.findByGroupName(name) != null &&
                monitoringGroupRepository.findByGroupName(name).getGroupNum() != groupNum){
            return "fail";
        }

        //그룹 Num +1하여 생성
        if(flag.equals("insert")) {
            group = new MonitoringGroup();
            int newGroupNum = monitoringGroupRepository.findAllBy_idNotNullOrderByGroupNumDesc().get(0).getGroupNum() + 1;
            group.setGroupNum(newGroupNum);

        //수정할 그룹의 멤버 모두 default로 초기화
        }else if(flag.equals("edit")){
            group = monitoringGroupRepository.findByGroupNum(groupNum);
            if(group.getGroupMember() != null) {
                for (int i = 0; i < group.getGroupMember().size(); i++) {
                    Member defaultMember = memberRepository.findById((String) group.getGroupMember().get(i));
                    defaultMember.setMonitoringGroup("default");
                    memberRepository.save(defaultMember);
                }
            }
        }

        //그룹의 멤버 모두 그룹명으로 변경
        if(memList != null) {
            for (int i = 0; i < memList.size(); i++) {
                //이전그룹에서 멤버 삭제
                MonitoringGroup prevGroup = monitoringGroupRepository.findByGroupMemberIsIn(memList.get(i));
                for (int k=0; k<prevGroup.getGroupMember().size(); k++){
                    if(prevGroup.getGroupMember().get(k).equals(memList.get(i))){
                        prevGroup.getGroupMember().remove(k);
                        monitoringGroupRepository.save(prevGroup);
                    }
                }

                Member saveMember = memberRepository.findById(memList.get(i));
                saveMember.setMonitoringGroup(name);
                memberRepository.save(saveMember);
            }
             group.setGroupMember(memList);
        }else{
            group.setGroupMember(null);
        }

        if(placeList != null){
            group.setMonitoringPlace(placeList);
        }else{
            group.setMonitoringPlace(null);
        }

        //그룹에 데이터 셋팅하고 저장
        group.setGroupName(name);
        monitoringGroupRepository.save(group);
        return "success";
    }

    /**
     * 그룹 삭제 하면서 멤버의 그룹명도 default로 변경
     * @param key 식별 키
     */
    @RequestMapping(value = "/deleteGroup", method = RequestMethod.POST)
    public void deleteGroup(int key) {

        MonitoringGroup group = monitoringGroupRepository.findByGroupNum(key);
        if(group.getGroupMember() != null) {
            for (int i = 0; i < group.getGroupMember().size(); i++) {
                Member saveMember = memberRepository.findById((String) group.getGroupMember().get(i));
                saveMember.setMonitoringGroup("default");
                memberRepository.save(saveMember);
            }
        }
        monitoringGroupRepository.delete(group);
    }

    /**
     * 그룹 생성, 수정등에 필요한 멤버, 측정소 리스트
     * @return 두개를 포함한 하나의 리스트 반환
     */
    @RequestMapping(value = "/getMemberAndPlaceList", method = RequestMethod.POST)
    public List getMemberAndPlaceList() {
        List<Place> pList = placeRepository.findAll();
        List placeName = new ArrayList();
        for (int i=0; i<pList.size(); i++){
            placeName.add(pList.get(i).getName());
        }

        List mpList = new ArrayList();
        mpList.add(memberRepository.findAll());
        mpList.add(placeName);

        return mpList;
    }
}
