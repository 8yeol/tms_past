package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.repository.DataInquiry.DataInquiryRepository;
import com.example.tms.repository.MonthlyEmissionsRepository;
import com.example.tms.repository.NotificationList.NotificationListRepository;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

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
    final MemberRepository memberRepository;
    final MemberService memberService;
    final RankManagementRepository rankManagementRepository;
    final RankManagementService rankManagementService;
    final PasswordEncoder passwordEncoder;
    final MonitoringGroupRepository monitoringGroupRepository;
    final NotificationListRepository notificationListRepository;

    public AjaxController(PlaceRepository placeRepository, LogRepository logRepository, SensorCustomRepository sensorCustomRepository, ReferenceValueSettingRepository reference_value_settingRepository, NotificationSettingsRepository notification_settingsRepository, NotificationListCustomRepository notificationListCustomRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, NotificationStatisticsCustomRepository notificationStatisticsCustomRepository, NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, AnnualEmissionsRepository annualEmissionsRepository, EmissionsSettingRepository emissionsSettingRepository, DataInquiryRepository dataInquiryCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, ItemRepository itemRepository, MongoQuary mongoQuary, MemberRepository memberRepository, MemberService memberService, RankManagementRepository rankManagementRepository, RankManagementService rankManagementService, PasswordEncoder passwordEncoder, MonitoringGroupRepository monitoringGroupRepository, NotificationListRepository notificationListRepository) {
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
        this.monitoringGroupRepository = monitoringGroupRepository;
        this.notificationListRepository = notificationListRepository;
    }

    /**
     * 전체 측정소 정보를 읽어오기 위한 메소드
     *
     * @return 전체 측정소 정보
     */
    @RequestMapping(value = "/getPlaceList")
    public List<Place> getPlaceList(Principal principal) {
        Map<String, List> gMS = getMonitoringSensor(principal.getName()); //사용자 권한에 해당하는 모니터링 On인 측정소, 센서 정보
        List<String> gMS_placeName = new ArrayList<>();
        List<Place> newList = new ArrayList<>();
        for (String key : gMS.keySet()) { //key(측정소명) 추출
            gMS_placeName.add(key);
        }
        int placeListSize = gMS.size() - 2;
        List<Place> placeAll = placeRepository.findAll();
        for (int a = 0; a < placeListSize; a++) {
            for (int b = 0; b < placeAll.size(); b++) {
                if (gMS_placeName.get(a).equals(placeAll.get(b).getName())) {
                    int sensorSize = gMS.get(gMS_placeName.get(a)).size();
                    if (sensorSize != 0) {
                        newList.add(placeAll.get(b));
                    }
                }
            }
        }
        return newList;
    }

    @RequestMapping(value = "/getPlaceList2")
    public Object getPlaceList2() {
        List<Place> placeName = placeRepository.findAll();
        JSONArray array = new JSONArray();
        for (int i = 0; i < placeName.size(); i++) {
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
     * @param place       측정소명
     * @param naming      중복 체크할 센서명  --추가
     * @param edit_naming 중복 체크할 센서명  -- 수정
     * @return 해당 측정소에 등록된 센서 값
     */
    @RequestMapping(value = "/isNamingEquals")
    public String isNamingEquals(String place, @RequestParam(value = "naming", required = false) String naming, @RequestParam(value = "edit_naming", required = false) String edit_naming) {
        Place placeObject = placeRepository.findByName(place);

        if (null == edit_naming) {  //추가
            if (placeObject.getSensor().size() != 0) {
                for (int i = 0; i < placeObject.getSensor().size(); i++) {
                    if (sensorListRepository.findByTableName(placeObject.getSensor().get(i) + "").getNaming().equals(naming))
                        return "addFalse";
                }
            }
        }

        if (null == naming) {  //수정
            if (placeObject.getSensor().size() != 0) {
                for (int i = 0; i < placeObject.getSensor().size(); i++) {
                    if (sensorListRepository.findByTableName(placeObject.getSensor().get(i) + "").getNaming().equals(edit_naming))
                        return "editFalse";
                }
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

        for (int i = 0; i < place.getSensor().size(); i++) {
            if (notification_settingsRepository.findByName(place.getSensor().get(i) + "") == null) {
                notificationList.add(sensorListRepository.findByTableName(place.getSensor().get(i) + ""));
                //return notificationList;
            } else {
                NotificationSettings notification = notification_settingsRepository.findByName(place.getSensor().get(i) + "");
                notification.setName(notification.getName() + "," + sensorListRepository.findByTableName(place.getSensor().get(i) + "").getNaming());
                notificationList.add(notification);
            }
        }
        return notificationList;
    }

    /**
     * 측정소 명의 센서명으로 모든 상세 기준값 리턴
     *
     * @param place 측정소 이름
     * @return 센서의 법적기준,사내기준,관리기준,모니터링 값
     */
    @RequestMapping(value = "/getPlaceSensorValue")
    public Object getPlaceSensorValue(String place, Principal principal) {
        List<String> sensorName = placeRepository.findByName(place).getSensor();
        List<ReferenceValueSetting> valueList = new ArrayList();
        List<ReferenceValueSetting> valueListCopy = new ArrayList();

        //회원이 속한 그룹 검색
        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(principal.getName());

        //센서명으로 상세설정값 목록 생성
        for (int i = 0; i < sensorName.size(); i++) {
            valueList.add(reference_value_settingRepository.findByName(sensorName.get(i)));
            valueListCopy.add(reference_value_settingRepository.findByName(sensorName.get(i)));
        }

        //관리자 그룹은 실제 ReferenceValueSetting 반환
        if (group.getGroupNum() == 1) return valueList;

        List<String> sensorList = group.getSensor();

        //해당 그룹의 센서목록이 하나도 없다면 모두 false
        if (sensorList == null || sensorList.size() == 0) {
            for (int i = 0; i < valueList.size(); i++)
                valueList.get(i).setMonitoring(false);
            return valueList;

        } else {
            //복사본 모두 false하고 원본으로 검사후 복사본 설정 및 리턴
            for (int i = 0; i < valueList.size(); i++) {
                valueListCopy.get(i).setMonitoring(false);
                for (int k = 0; k < sensorList.size(); k++) {
                    if (sensorList.get(k).equals(valueListCopy.get(i).getName()) && valueList.get(i).getMonitoring() == true) {
                        valueListCopy.get(i).setMonitoring(true);
                        break;
                    }
                }
            }
            return valueListCopy;
        }

    }

    /**
     * 해당 측정소명의 모니터링 True 인 센서를 받아와 해당 센서의 최근, 이전, 정보들을 읽어오기 위한 메소드
     *
     * @param place 측정소 이름
     * @return 센서의 최근, 이전, 정보
     */
    @RequestMapping(value = "/getPlaceData")
    public JSONArray getPlaceData(String place, Principal principal) {
        try {
            Map<String, List> gMS = getMonitoringSensor(principal.getName()); //사용자 권한에 해당하는 모니터링 On인 측정소, 센서 정보
            if (place != null) {
                List<String> sensorNames = gMS.get(place);
                JSONArray jsonArray = new JSONArray();
                for (int i = 0; i < sensorNames.size(); i++) {
                    JSONObject subObj = new JSONObject();
                    String sensorName = sensorNames.get(i);
                    boolean monitoring = reference_value_settingRepository.findByName(sensorName).getMonitoring();
                    if (monitoring) { //monitoring true
                        String[] splitSensor = sensorName.split("_");
                        Item sensorItem = itemRepository.findByClassification(splitSensor[1]);
                        Sensor recentData = sensorCustomRepository.getSensorRecent(sensorName);
                        subObj.put("place", place);
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
                        subObj.put("max", numberTypeChange(sensorInfo.getMax()));
                        subObj.put("min", numberTypeChange(sensorInfo.getMin()));
                        if (sensorItem != null) {
                            subObj.put("unit", sensorItem.getUnit());
                        } else {
                            subObj.put("unit", "");
                        }
                        jsonArray.add(subObj);
                    }
                }
                return jsonArray;
            }
        } catch (Exception e) {
            //java.lang.IndexOutOfBoundsException: Index: 0, Size: 0
        }
        return null;
    }

    /**
     * 소수점 아래 존재 .0 일 경우 정수로 바꿔주는 메소드
     *
     * @param number
     * @return 정수형/실수형
     */
    public Object numberTypeChange(float number) {
        if (number - Math.round(number) == 0) { //소수점 아래 0일때
            return (int) number;
        } else {
            return Math.round(number * 100) / 100.0;
        }
    }


    /**
     * 해당 센서의 모터링이 True 인 센서 데이터(최근,이전,기준값 등) Json형태로 리턴하는 메소드
     *
     * @param sensor 센서명
     * @return 센서의 최근, 이전, 정보
     */
    @RequestMapping(value = "/getSensorData")
    public Object getSensorData(String sensor) {
        boolean monitoring = reference_value_settingRepository.findByName(sensor).getMonitoring();
        JSONObject subObj = new JSONObject();
        if (monitoring) {
            String[] splitSensor = sensor.split("_");
            Item sensorItem = itemRepository.findByClassification(splitSensor[1]);
            try {
                Sensor recentData = sensorCustomRepository.getSensorRecent(sensor);
                subObj.put("value", recentData.getValue());
                subObj.put("up_time", recentData.getUp_time());
                subObj.put("status", recentData.isStatus());
            } catch (Exception e) {
                return null;
            }
            try {
                Sensor beforeData = sensorCustomRepository.getSensorBeforeData(sensor);
                subObj.put("beforeValue", beforeData.getValue());
            } catch (Exception e) {
                subObj.put("beforeValue", 0);
            }
            ReferenceValueSetting sensorInfo = reference_value_settingRepository.findByName(sensor);
            subObj.put("naming", sensorInfo.getNaming());
            subObj.put("legalStandard", numberTypeChange(sensorInfo.getLegalStandard()));
            subObj.put("companyStandard", numberTypeChange(sensorInfo.getCompanyStandard()));
            subObj.put("managementStandard", numberTypeChange(sensorInfo.getManagementStandard()));
            subObj.put("name", sensor);
            subObj.put("max", numberTypeChange(sensorInfo.getMax()));
            subObj.put("min", numberTypeChange(sensorInfo.getMin()));
            if (sensorItem != null) {
                subObj.put("unit", sensorItem.getUnit());
            } else {
                subObj.put("unit", "");
            }
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
        if (check == false) {
            for (int j = 0; j < sensorlist.size(); j++) {
                SensorList sen = sensorListRepository.findByTableName(sensorlist.get(j), "");
                String senname = sen.getNaming();
                if (notification_settingsRepository.findByName(sensorlist.get(j)) != null) {
                    notification_settingsRepository.deleteByName(sensorlist.get(j));
                    inputLogSetting("'" + senname + "'" + " 알림설정 값 삭제", "설정", principal);
                }

            }
        }
        placeRepository.save(savePlace);
        return savePlace.getUp_time();
    }

    public void groupSensorRemove(String sensorName) {
        //삭제될 센서를 포함하는 그룹 검색하여 센서 삭제
        List<MonitoringGroup> groups = monitoringGroupRepository.findBySensorIsIn(sensorName);
        if (groups != null && groups.size() != 0) {
            for (int i = 0; i < groups.size(); i++) {
                List<String> sensorList = groups.get(i).getSensor();
                if (sensorList != null && sensorList.size() != 0) {
                    for (int k = 0; k < sensorList.size(); k++) {
                        if (sensorList.get(k).equals(sensorName))
                            sensorList.remove(k);
                    }
                }
                groups.get(i).setSensor(sensorList);
                monitoringGroupRepository.save(groups.get(i));
            }
        }
    }

    /**
     * 측정항목 모니터링 변경
     * 현재 모니터링값 반대로 적용
     *
     * @param tablename 센서명
     */
    @RequestMapping(value = "/referenceMonitoringUpdate")
    public String referenceMonitoringUpdate(@RequestParam("sensor") String tablename, Principal principal) {
        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(principal.getName());
        List<String> sensorList = group.getSensor();

        //관리자 그룹이라면 실제 reference_value_setting 을 조작
        if (group.getGroupNum() == 1) {
            ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
            reference.setMonitoring(!reference.getMonitoring());
            reference_value_settingRepository.save(reference);
            groupSensorRemove(tablename);
            return "";
        }

        if (reference_value_settingRepository.findByName(tablename).getMonitoring() == false) {
            return "permissionError";
        }

        //센서목록 하나도 없다면
        if (sensorList == null || sensorList.size() == 0) {
            sensorList = new ArrayList<>();
            sensorList.add(tablename);
            group.setSensor(sensorList);
            monitoringGroupRepository.save(group);
            return "";
        }

        //설정된 센서가 그룹의 센서목록에 있다면 On -> Off로 간주하고 목록에서 삭제 후 리턴
        for (int i = 0; i < sensorList.size(); i++) {
            if (sensorList.get(i).equals(tablename)) {
                sensorList.remove(tablename);
                group.setSensor(sensorList);
                monitoringGroupRepository.save(group);
                return "";
            }
        }

        //설정된 센서가 그룹에 없다면 Off -> On 으로 간주하고 목록에 추가후 리턴
        sensorList.add(tablename);
        group.setSensor(sensorList);
        monitoringGroupRepository.save(group);
        return "";
    }

    /**
     * 전체 센서 정보 리스트
     *
     * @return 전체 센서 정보보
     */
    @RequestMapping(value = "getSensorList")
    public List<SensorList> getSensorList() {

        List<SensorList> sensorList = sensorListRepository.findAll();

        for (SensorList sensor : sensorList) {
            sensor.getTableName();

            Sensor sensorData = sensorCustomRepository.getSensorRecent(sensor.getTableName());

            Date now = new Date();
            long diff = now.getTime() - sensorData.getUp_time().getTime();
            long sec = diff / 60000;

            if (sec < 5) {
                sensor.setStatus(true);
            } else {
                sensor.setStatus(false);
            }
        }

        return sensorList;
    }

    /**
     * 설정된 기준 값을 초과하는 경우 알람 발생 - 해당 발생된 알람의 목록 리스트 (from - to 사이 데이터)
     *
     * @return 전체 알람 목록
     */
    @RequestMapping(value = "/getNotificationList")
    public Object getNotificationList(String from, String to, String placeName) {
        return mongoQuary.getNotificationList(from, to, placeName);
    }

    @RequestMapping(value = "/getExcessSensor", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getExcessSensor(Principal principal) {
        Member member = memberRepository.findById(principal.getName());
        int memberGroup = member.getMonitoringGroup();
        JSONObject excess = new JSONObject();

        List<String> sensorList = new ArrayList<>();
        if (memberGroup != 1) {
            MonitoringGroup monitoringGroup = monitoringGroupRepository.findByGroupNum(memberGroup);
            sensorList = monitoringGroup.getSensor();
        } else {
            List<ReferenceValueSetting> monitoringOn = reference_value_settingRepository.findByMonitoringIsTrue();
            for (ReferenceValueSetting referenceValueSetting : monitoringOn) {
                sensorList.add(referenceValueSetting.getName());
            }
        }

        if (sensorList != null) {
            excess = getExcessList(sensorList);
        }
        return excess;
    }

    public JSONObject getExcessList(List<String> sensorList) {
        JSONObject excess = new JSONObject();
        JSONArray jsonArray = new JSONArray();

        for (String sensorName : sensorList) {
            Sensor sensor = sensorCustomRepository.getSensorRecent(sensorName);
            ReferenceValueSetting referenceValueSetting = reference_value_settingRepository.findByName(sensorName);
            Date now = new Date();
            long diff = now.getTime() - sensor.getUp_time().getTime();
            long sec = diff / 60000;

            if (sec < 5) {
                float value = sensor.getValue();
                SensorList sensorInfo = sensorListRepository.findByTableName(referenceValueSetting.getName());
                ;
                JSONObject jsonObject = new JSONObject();

                if (value > referenceValueSetting.getLegalStandard()) {
                    jsonObject.put("classification", "danger");
                } else if (value > referenceValueSetting.getCompanyStandard()) {
                    jsonObject.put("classification", "warning");
                } else if (value > referenceValueSetting.getManagementStandard()) {
                    jsonObject.put("classification", "caution");
                } else {
                    jsonObject.put("classification", "normal");
                }

                jsonObject.put("place", sensorInfo.getPlace());
                jsonObject.put("naming", sensorInfo.getNaming());
                jsonObject.put("value", String.format("%.2f", value));
                jsonObject.put("up_time", sensor.getUp_time());
                jsonArray.add(jsonObject);
                excess.put("excess", jsonArray);
            }
        }
        return excess;
    }

    /**
     * 그룹마다 허용된 센서 리스트 검색하여 기준초과 데이터 가져오기
     *
     * @param principal 로그인 객체
     * @return 기준 초과데이터
     */
    @RequestMapping(value = "/getAlarmData", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmData(Principal principal, @RequestParam("num") String num) throws ParseException {
        //로그인 객체 없다면 null 리턴하여 login.jsp로 이동
        if (principal == null) {
            JSONObject memberIsNull = new JSONObject();
            memberIsNull.put("null", "null");
            return memberIsNull;
        }

        Member member = memberRepository.findById(principal.getName()); //아이디 확인
        int memberGroup = member.getMonitoringGroup();

        JSONArray array = new JSONArray();

        List<String> sensorList = new ArrayList<>();
        if (memberGroup != 1) { //디폴트 그룹이 아닐때
            MonitoringGroup monitoringGroup = monitoringGroupRepository.findByGroupNum(memberGroup); //모니터링 그룹
            List<String> placeList = monitoringGroup.getMonitoringPlace(); //측정소리스트
            for (int i = 0; i < placeList.size(); i++) {
                Place place = placeRepository.findByName(placeList.get(i));//측정소 정보
                List<String> placeSensor = place.getSensor();//측정소 센서
                for (int k = 0; k < placeSensor.size(); k++) {
                    if (notification_settingsRepository.findByName(placeSensor.get(k)).isStatus() == true) { //측정소센서 알림 on 확인
                        sensorList.add(placeSensor.get(k));
                    }
                }
            }
        } else { //디폴트그룹일때
            List<NotificationSettings> monitoringOn = notification_settingsRepository.findByStatusIsTrue(); //알림 on 확인
            for (NotificationSettings notificationSettings : monitoringOn) {
                sensorList.add(notificationSettings.getName());
            }
        }
        if (sensorList != null) {
            if (num.equals("1")) {
                getAlarmDataCheck(sensorList);
                array = getAlarmNotificationList(sensorList);
            } else {
                array = getAlarmNotificationList(sensorList);
            }
        }
        return array;
    }

    /**
     * 모니터링그룹에 해당되는 센서의 알림리스트 가져오기
     *
     * @param sensorList 해당 관리자가 포함된 모니터링 그룹의 센서리스트
     * @return 알림리스트 데이터
     */
    @RequestMapping(value = "/getAlarmNotificationList")
    public JSONArray getAlarmNotificationList(List<String> sensorList) {
        JSONArray array = new JSONArray();
        for (int i = 0; i < sensorList.size(); i++) {
            List<NotificationList> notificationList = notificationListRepository.findByNameAndCheck(sensorList.get(i), false);
            List<NotificationList> falseCount = notificationListRepository.findByCheck(false);
            if (notificationList.size() > 1) {
                for (int j = 0; j < notificationList.size(); j++) {
                    JSONObject excess = new JSONObject();
                    excess.put("name", notificationList.get(j).getName());
                    excess.put("sensor", notificationList.get(j).getSensor());
                    excess.put("value", notificationList.get(j).getValue());
                    excess.put("place", notificationList.get(j).getPlace());
                    excess.put("grade", notificationList.get(j).getGrade());
                    excess.put("status", notificationList.get(j).getStatus());
                    excess.put("up_time", notificationList.get(j).getUp_time());
                    if (array.size() < falseCount.size()) {
                        array.add(excess);
                    }
                }
            } else if (notificationList.size() == 1) {
                JSONObject excess = new JSONObject();
                excess.put("name", notificationList.get(0).getName());
                excess.put("sensor", notificationList.get(0).getSensor());
                excess.put("value", notificationList.get(0).getValue());
                excess.put("place", notificationList.get(0).getPlace());
                excess.put("grade", notificationList.get(0).getGrade());
                excess.put("status", notificationList.get(0).getStatus());
                excess.put("up_time", notificationList.get(0).getUp_time());
                if (array.size() < falseCount.size()) {
                    array.add(excess);
                }
            }
        }
        return array;
    }

    /**
     * 기준초과 알람에 필요한 데이터 설정
     *
     * @param sensorList 센서 리스트
     * @return 기준초과 데이터
     */
    public void getAlarmDataCheck(List<String> sensorList) throws ParseException {
        JSONArray jsonArray = new JSONArray();

        for (String sensorName : sensorList) {
            Sensor sensor = sensorCustomRepository.getSensorRecent(sensorName); //최근 입력된 센서
            ReferenceValueSetting referenceValueSetting = reference_value_settingRepository.findByName(sensorName);

            float value = sensor.getValue(); //센서 값
            SensorList sensorInfo = sensorListRepository.findByTableName(referenceValueSetting.getName());
            ;
            JSONObject jsonObject = new JSONObject();

            if (value > referenceValueSetting.getLegalStandard()) {
                jsonObject.put("classification", "danger");
            } else if (value > referenceValueSetting.getCompanyStandard()) {
                jsonObject.put("classification", "warning");
            } else if (value > referenceValueSetting.getManagementStandard()) {
                jsonObject.put("classification", "caution");
            } else {
                jsonObject.put("classification", "normal");
            }

            SensorList sensorData = sensorListRepository.findByPlaceAndNaming(sensorInfo.getPlace(), sensorInfo.getNaming());
            NotificationSettings setting = notification_settingsRepository.findByName(sensorData.getTableName());
            if (setting != null) {
                Date date = new Date(System.currentTimeMillis());
                SimpleDateFormat format = new SimpleDateFormat("HH:mm");

                Date startDate = format.parse(setting.getStart());
                Date endDate = format.parse(setting.getEnd());
                Date nowDate = format.parse(format.format(date));

                if (nowDate.after(startDate) && endDate.after(nowDate) && setting.isStatus() == true) {
                    jsonObject.put("state", true);
                } else {
                    jsonObject.put("state", false);
                }
            } else {
                jsonObject.put("state", false);
            }

            jsonObject.put("place", sensorInfo.getPlace());
            jsonObject.put("naming", sensorInfo.getNaming());
            jsonObject.put("tableName", sensorInfo.getTableName());
            jsonObject.put("value", String.format("%.2f", value));
            jsonObject.put("up_time", sensor.getUp_time());
            jsonArray.add(jsonObject);

        }
        saveNotificationList(jsonArray);
    }

    /**
     * notification_list 저장 메소드
     *
     * @param jsonArray 센서별 최근 데이터 리스트
     */
    public void saveNotificationList(JSONArray jsonArray) {
        for (int i = 0; i < jsonArray.size(); i++) {
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);
            int grade = 0;
            String classification = jsonObject.get("classification").toString();
            if (classification == "danger" || classification == "warning") {
                if (classification == "danger") {
                    grade = 1;
                } else {
                    grade = 2;
                }
                String place = jsonObject.get("place").toString();
                String sensor = jsonObject.get("naming").toString();
                String name = jsonObject.get("tableName").toString();
                String value = jsonObject.get("value").toString();
                String status = jsonObject.get("state").toString();
                boolean check = false;
                String checkName = "";
                Date time = (Date) jsonObject.get("up_time");

                List<NotificationList> tf = notificationListRepository.findBySensor(sensor);
                if (tf.size() != 0) { //데이터 중복 확인(센서확인)
                    int count = 0;
                    for (int j = 0; j < tf.size(); j++) {
                        Date a = tf.get(j).up_time;
                        if (a.equals(time)) {
                            count++;
                        }
                    }
                    if (grade >= 1 && count == 0) {
                        NotificationList list = new NotificationList(place, sensor, name, value, grade, status, check, checkName, time);
                        notificationListRepository.save(list);
                    }
                } else {
                    if (grade >= 1) {
                        NotificationList list = new NotificationList(place, sensor, name, value, grade, status, check, checkName, time);
                        notificationListRepository.save(list);
                    }
                }
            }
        }
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
    @RequestMapping(value = "/saveCheck")
    public void savePlace(@RequestParam(value = "name") String name, @RequestParam(value = "sensor") String sensor, @RequestParam(value = "uptime") String up_time, Principal principal) {
        List<NotificationList> notificationList = notificationListRepository.findBySensor(sensor);
        for (int i = 0; i < notificationList.size(); i++) {
            Date date = notificationList.get(i).up_time;
            SimpleDateFormat trans = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String transDate = trans.format(date);
            if (transDate.equals(up_time)) {
                String value = notificationList.get(i).value;
                notificationList.get(i).setCheck(true);
                notificationList.get(i).setCheckName(name);
                notificationListRepository.save(notificationList.get(i));

                if (notificationList.get(i).grade == 1) {
                    inputLogSetting("'" + sensor + "'" + " 법적기준 초과(" + value + ") 알림 확인('" + name + "')", "설정", principal);
                } else if (notificationList.get(i).grade == 2) {
                    inputLogSetting("'" + sensor + "'" + " 사내기준 초과(" + value + ") 알림 확인('" + name + "')", "설정", principal);
                } else {
                    inputLogSetting("'" + sensor + "'" + " 관리기준 초과(" + value + ") 알림 확인('" + name + "')", "설정", principal);
                }
            }
        }
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
            Boolean monitoring = true;
            List sensor = new ArrayList();
            Place newplace = new Place(name, location, admin, tel, monitoring, date, sensor);
            inputLogSetting("측정소 추가 > " + "'" + name + "'", "설정", principal);
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
                inputLogSetting("'" + hiddenCode + " - " + sensorlist.get(i).naming + "'" + " 센서 측정소명 '" + name + "' 수정", "설정", principal);
                sensorListRepository.save(sensor);
            }

            List<EmissionsStandardSetting> ess = emissionsStandardSettingRepository.findByPlace(hiddenCode);
            for (int i = 0; i < ess.size(); i++) {
                ess.get(i).setPlace(name);
                ess.get(i).setDate(new Date());
                inputLogSetting("'" + hiddenCode + " - " + ess.get(i).getNaming() + "'" + " 배출 관리 기준 측정소명 '" + name + "' 수정", "설정", principal);
                emissionsStandardSettingRepository.save(ess.get(i));
            }
            List<AnnualEmissions> ae = annualEmissionsRepository.findByPlace(hiddenCode);
            for (int i = 0; i < ae.size(); i++) {
                ae.get(i).setPlace(name);
                inputLogSetting("'" + hiddenCode + " - " + ae.get(i).getSensorNaming() + "'" + " 배출량 연간 모니터링 측정소명 '" + name + "' 수정", "설정", principal);
                annualEmissionsRepository.save(ae.get(i));
            }
            List<EmissionsSetting> es = emissionsSettingRepository.findByPlace(hiddenCode);
            for (int i = 0; i < es.size(); i++) {
                es.get(i).setPlace(name);
                inputLogSetting("'" + hiddenCode + " - " + es.get(i).getSensorNaming() + "'" + " 배출량 모니터링 측정소명 '" + name + "' 수정", "설정", principal);
                emissionsSettingRepository.save(es.get(i));
            }

            inputLogSetting("'" + hiddenCode + "' > '" + name + "' 측정소명 수정", "설정", principal);

            List<MonitoringGroup> group = monitoringGroupRepository.findByMonitoringPlaceIsIn(hiddenCode);
            if (group != null) {
                for (int i = 0; i < group.size(); i++) {
                    List<String> groupPlaceList = group.get(i).getMonitoringPlace();
                    int index = groupPlaceList.indexOf(hiddenCode);
                    groupPlaceList.set(index, name);
                    group.get(i).setMonitoringPlace(groupPlaceList);
                    monitoringGroupRepository.save(group.get(i));
                }
                inputLogSetting("'" + hiddenCode + "' > '" + name + "' 해당 측정소가 포함된 그룹의 측정소명 변경", "설정", principal);
            }
        }
    }

    /**
     * 측정소에있는 센서 개수 확인
     *
     * @param placeList 측정소 배열
     * @return
     */
    @RequestMapping(value = "/countPlaceSensor")
    public int countPlaceSensor(@RequestParam(value = "placeList[]") List<String> placeList) {
        int count = 0;
        for (int i = 0; i < placeList.size(); i++) {
            List<String> placeSensorList = placeRepository.findByName(placeList.get(i)).getSensor();
            count += placeSensorList.size();
        }
        return count;
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
            //삭제할 측정소의 센서 목록
            List<String> placeSensorList = placeRepository.findByName(placeList.get(i)).getSensor();
            //삭제될 측정소 그룹에서 삭제
            List<MonitoringGroup> group = monitoringGroupRepository.findByMonitoringPlaceIsIn(placeList.get(i));
            for (int k = 0; k < group.size(); k++) {
                List<String> groupPlaceList = group.get(k).getMonitoringPlace();
                groupPlaceList.remove(placeList.get(i));
                group.get(k).setMonitoringPlace(groupPlaceList);
                monitoringGroupRepository.save(group.get(k));
                if (!group.get(k).getMonitoringPlace().get(0).equals("모든 측정소")) {
                    inputLogSetting("'" + group.get(k).getGroupName() + "'그룹의 측정소 '" + placeList.get(i) + "' 삭제", "삭제", principal);
                }

                //삭체할 측정소가 포함된 그룹의 센서 목록
                List<String> groupSensorList = group.get(k).getSensor();

                if (groupSensorList != null && groupSensorList.size() != 0) {
                    //그룹의 센서 목록에서 삭제될 센서 삭제
                    for (int j = 0; j < placeSensorList.size(); j++) {
                        for (int p = 0; p < groupSensorList.size(); p++) {
                            if (groupSensorList.get(p).contains(placeSensorList.get(j))) {
                                groupSensorList.remove(p);
                                inputLogSetting("'" + group.get(k).getGroupName() + "'그룹의 센서  '" + groupSensorList.get(p) + "' 삭제", "삭제", principal);
                            }
                        }
                    }
                }
                group.get(k).setSensor(groupSensorList);
                monitoringGroupRepository.save(group.get(k));
            } // -- for

            if (flag) {
                removePlaceRemoveSensor(placeList.get(i), principal);       //센서 포함 삭제
            } else {
                removePlaceChangeSensor(placeList.get(i), principal);       //측정소만 삭제
            }
        }// ----for
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
                inputLogSetting("'" + sensorname + "'" + " 알림설정 초기화", "설정", principal);
                notification_settingsRepository.save(no);
            }

            //배출량 관리 - 모니터링 대상 False 설정
            EmissionsSetting em = emissionsSettingRepository.findBySensor(sensor.get(i));
            if (em != null) {
                em.setStatus(false);
                em.setPlace("");
                inputLogSetting("'" + sensorname + "'" + " 배출량 모니터링 OFF", "설정", principal);
                emissionsSettingRepository.save(em);
            }

            //배출량 관리 - 연간 모니터링 대상 False 설정
            AnnualEmissions aem = annualEmissionsRepository.findBySensor(sensor.get(i));
            if (aem != null) {
                aem.setStatus(false);
                aem.setPlace("");
                inputLogSetting("'" + sensorname + "'" + " 배출량 연간 모니터링 OFF", "설정", principal);
                annualEmissionsRepository.save(aem);
            }

            //센서 관리 - 측정소 값 삭제
            SensorList sl = sensorListRepository.findByTableName(sensor.get(i), "");
            if (sl != null) {
                sl.setPlace("");
                inputLogSetting("'" + sensorname + "'" + " 센서 등록 측정소 '" + place + "' 삭제", "설정", principal);
                sensorListRepository.save(sl);
            }

            //상세설정 모니터링 값 False
            ReferenceValueSetting rv = reference_value_settingRepository.findByName(sensor.get(i));
            if (rv != null) {
                rv.setMonitoring(false);
                inputLogSetting("'" + sensorname + "'" + " 모니터링 OFF", "설정", principal);
                reference_value_settingRepository.save(rv);
            }

            //배출 관리 기준 측정소값 삭제
            EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(sensor.get(i));
            if (ess != null) {
                ess.setPlace("");
                ess.setDate(new Date());
                inputLogSetting("'" + sensorname + "'" + " 배출 관리 기준 등록 측정소 '" + place + "' 삭제", "설정", principal);
                emissionsStandardSettingRepository.save(ess);
            }

        }
        //측정소 삭제
        inputLogSetting("'" + place + "' 삭제", "설정", principal);
        placeRepository.deleteByName(place);
    }

    /**
     * 측정소와 센서,상세설정값 동시에 삭제
     *
     * @param place 측정소명
     */
    public void removePlaceRemoveSensor(String place, Principal principal) {
        Place placeInfo = placeRepository.findByName(place);

        //측정소 삭제
        placeRepository.deleteByName(place);
        inputLogSetting("'" + place + "' 삭제", "설정", principal);

        List<String> sensor = placeInfo.getSensor();
        for (int i = 0; i < sensor.size(); i++) {
            String sensorCode = sensor.get(i).split("_")[1]; //-> NOX, IRS ..
            SensorList sen = sensorListRepository.findByTableName(sensor.get(i), "");
            String sensorname = sen.getNaming();
            reference_value_settingRepository.deleteByName(sensor.get(i));
            inputLogSetting("'" + sensorname + "'" + " 상세설정 값 삭제", "설정", principal);

            notification_settingsRepository.deleteByName(sensor.get(i));
            inputLogSetting("'" + sensorname + "'" + " 알림설정 값 삭제", "설정", principal);

            emissionsSettingRepository.deleteBySensor(sensor.get(i));
            inputLogSetting("'" + sensorname + "'" + " 배출량 모니터링 대상 삭제", "설정", principal);

            annualEmissionsRepository.deleteBySensor(sensor.get(i));
            inputLogSetting("'" + sensorname + "'" + " 배출량 연간 모니터링 대상 삭제", "설정", principal);

            emissionsStandardSettingRepository.deleteByTableName(sensor.get(i));
            inputLogSetting("'" + sensorname + "'" + " 배출 관리 기준 삭제", "설정", principal);

            sensorListRepository.deleteByTableName(sensor.get(i));
            inputLogSetting("'" + sensorname + "'" + " 센서 삭제", "설정", principal);

            if(sensorCode.equals("NOX")){
                //배출량 관리 - 연간 배출량 추이 삭제
                List<MonthlyEmissions> list = monthlyEmissionsRepository.findBySensor(sensor.get(i));
                for(int j=0; j<list.size(); j++){
                    monthlyEmissionsRepository.deleteBySensor(sensor.get(i));
                }
            }
            inputLogSetting("'" + sensorname + "'" + " 연간 배출량 추이 삭제", "설정", principal);
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
        List<SensorList> list = sensorListRepository.findByPlaceAndClassification(place, "NOX");
        return list;
    }

    /**
     * 테이블 명으로 센서 가져오기
     *
     * @param place 측정소명
     * @return 센서의 네이밍 리스트
     */
    @RequestMapping(value = "/findSensorListAll")
    public List findSensorCategoryListAll(@RequestParam("place") String place) {
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

    @RequestMapping(value = "/getSensor2")
    public List<Sensor> getSensor2(@RequestParam("sensor") String sensor,
                                   @RequestParam("min") String min) {
        return sensorCustomRepository.getSenor2(sensor, min);
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
    public void saveReference(String placename, String name, String naming, Principal principal) {
        inputLogSetting("'" + placename + " - " + naming + "'" + " 센서 관리 기준 값 설정", "설정", principal);

        if (placeRepository.findBySensorIsIn(name) != null) { //기존 센서가 존재
            //place 업데이트 시간 수정
            placeUpTime(placename);
        } else { //최초 입력
            Place placesensor = placeRepository.findByName(placename);
            List<String> sensor = placesensor.getSensor();
            sensor.add(name);
            placesensor.setSensor(sensor);
            placeRepository.save(placesensor);
            inputLogSetting("'" + placename + " - " + naming + "'" + " 센서 추가", "설정", principal);

        }
        float legal = 999999.0f;
        float company = 999999.0f;
        float management = 999999.0f;
        float max = 999999.0f;
        float min = 999999.0f;
        Boolean monitoring = false;

        //reference document 생성
        ReferenceValueSetting saveReference = new ReferenceValueSetting(name, naming, legal, company, management, min, max, monitoring);
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
     * 측정항목의 chartmax 업데이트
     *
     * @param name      측정소명
     * @param value     chartmax 값
     * @param tablename 테이블 명
     */
    @RequestMapping(value = "/chartmaxUpdate")
    public void chartmaxUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setMax(value);
        reference_value_settingRepository.save(reference);
        //측정소 업데이트
        placeUpTime(name);
    }

    /**
     * 측정항목의 chartmin 업데이트
     *
     * @param name      측정소명
     * @param value     chartmin 값
     * @param tablename 테이블 명
     */
    @RequestMapping(value = "/chartminUpdate")
    public void chartminUpdate(@RequestParam("place") String name, @RequestParam("value") Float value, @RequestParam("tablename") String tablename) {
        //측정항목 업데이트
        ReferenceValueSetting reference = reference_value_settingRepository.findByName(tablename);
        reference.setMin(value);
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
     * 당일 알림 현황 조회 메소드
     *
     * @return day(현재날짜), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNSNow")
    public ArrayList getNotificationStatistics(String place) {
        ArrayList al = new ArrayList();
        try {
            LocalDate nowDate = LocalDate.now();
            al.add(nowDate);
            for (int grade = 1; grade <= 3; grade++) {
                List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(nowDate), String.valueOf(nowDate), place);
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
    public List<NotificationDayStatistics> getNotificationWeekStatistics(@RequestParam(value = "place") String place) {
        return notificationStatisticsCustomRepository.getNotificationWeekStatistics(place);
    }

    /**
     * 월별 현황 조회 - 최근 1년 (limit:12)
     *
     * @return month(' yyyy - MM '), legalCount(법적기준초과), companyCount(사내기준초과), managementCount(관리기준초과)
     */
    @RequestMapping(value = "getNSMonth")
    public List<NotificationMonthStatistics> getNotificationMonthStatistics(@RequestParam(value = "place") String place) {
        return notificationStatisticsCustomRepository.getNotificationMonthStatistics(place);
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

        inputLogSetting("'" + setting.getPlace() + " - " + setting.getNaming() + "'" + " 센서 연간 배출 허용 기준 변경 ", "설정", principal);

        List<EmissionsStandardSetting> standardList = emissionsStandardSettingRepository.findAll();
        return standardList;
    }

    /**
     * 로그 셋팅해서 입력하는 메소드
     *
     * @param content   내용
     * @param type      타입
     * @param principal id
     */
    public void inputLogSetting(String content, String type, Principal principal) {
        inputLog(new Log(principal.getName(), content, type));
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
                           @RequestParam(value = "edit_naming", required = false) String edit_naming,
                           @RequestParam(value = "tableName", required = false) String tableName,
                           @RequestParam(value = "hiddenCode", required = false) String hiddenCode,
                           @RequestParam(value = "isValueDelete", required = false) String isValueDelete, Principal principal) {

        SensorList sensor;
        //hidden 값이 있는지로 추가와 수정을 판별
        //생성
        if (hiddenCode == null) {
            sensor = new SensorList(classification, naming, managementId, tableName, new Date(), place, true);

            //질소산화물만 배출 기준, 모니터링 대상 에 추가
            String sensorCode = tableName.split("_")[1]; //-> NOX, IRS ..
            if (sensorCode.equals("NOX")) {
                //연간 배출량 누적 모니터랑 대상 && 배출량 추이 모니터링 대상   설정에도 추가합니다.
                AnnualEmissions aEmissions = new AnnualEmissions(place, tableName, naming, 0, false, new Date());
                annualEmissionsRepository.save(aEmissions);
                inputLogSetting("'" + place + " - " + naming + "'" + " 센서 연간 배출량 모니터링 대상 추가", "설정", principal);

                //배출량 추이 모니터링 대상 설정 생성
                EmissionsSetting emissions = new EmissionsSetting(place, tableName, naming, false);
                emissionsSettingRepository.save(emissions);
                inputLogSetting("'" + place + " - " + naming + "'" + " 센서 배출량 추이 모니터링 대상 추가", "설정", principal);

                //연간 배출 허용 기준 생성
                EmissionsStandardSetting ess = new EmissionsStandardSetting(place, naming, 0, 0, tableName, "", new Date());
                emissionsStandardSettingRepository.save(ess);
                inputLogSetting("'" + place + " - " + naming + "'" + " 센서 연간 배출 허용 기준 추가", "설정", principal);
            }
            // 추가
            saveNotifySetting(tableName, false, "00:00", "23:59");
            saveReference(place, tableName, naming, principal); //상세설정 항목 추가
            inputLogSetting("'" + sensor.getNaming() + "'" + " 센서 추가", "설정", principal);

        } else { //수정
            sensor = sensorListRepository.findByTableName(hiddenCode, "");
            String oldPlace = sensor.getPlace();
            String oldNaming = sensor.getNaming();
            sensor.setPlace(place);
            sensor.setNaming(edit_naming);
            sensor.setUpTime(new Date());

            if (oldPlace.equals("")) oldPlace = "측정소 없음";

            //센서관련 법적기준,사내기준,관리기준값 사용자 동의하에 초기화
            if (isValueDelete.equals("delete")) {
                ReferenceValueSetting reference = reference_value_settingRepository.findByName(hiddenCode);
                reference.setLegalStandard(999999.0f);
                reference.setCompanyStandard(999999.0f);
                reference.setManagementStandard(999999.0f);
                reference.setMin(999999.0f);
                reference.setMax(999999.0f);
                reference.setNaming(edit_naming);
                reference.setMonitoring(false);
                reference_value_settingRepository.save(reference);
                inputLogSetting("'" + oldPlace + " - " + sensor.getNaming() + "'" + " 관리 기준 초기화", "설정", principal);
            }

            //항목명 변경
            if (!oldNaming.equals(edit_naming)) {

                //질소산화물만 수정
                String sensorCode = hiddenCode.split("_")[1]; //-> NOX, IRS ..
                if (sensorCode.equals("NOX")) {
                    //연간 배출 모니터링 대상 수정
                    AnnualEmissions aemis = annualEmissionsRepository.findBySensor(hiddenCode);
                    aemis.setSensorNaming(edit_naming);
                    aemis.setStatus(false);
                    annualEmissionsRepository.save(aemis);
                    inputLogSetting("'" + oldPlace + " - " + sensor.getNaming() + "'" + " 센서 연간 배출 모니터링 대상 항목명 수정", "설정", principal);

                    //배출 모니터링 대상 수정
                    EmissionsSetting emis = emissionsSettingRepository.findBySensor(hiddenCode);
                    emis.setSensorNaming(edit_naming);
                    emis.setStatus(false);
                    emissionsSettingRepository.save(emis);
                    inputLogSetting("'" + oldPlace + " - " + sensor.getNaming() + "'" + " 센서 배출량 추이 모니터링 대상 항목명 수정", "설정", principal);

                    //배출 관리 기준 수정
                    EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenCode);
                    ess.setNaming(edit_naming);
                    ess.setDate(new Date());
                    emissionsStandardSettingRepository.save(ess);
                    inputLogSetting("'" + oldPlace + " - " + sensor.getNaming() + "'" + " 센서 연간 배출 허용 기준 항목명 수정", "설정", principal);
                }

                inputLogSetting("'" + oldNaming + "' 센서의 항목명 " + "'" + oldNaming + "'" + " > " + "'" + edit_naming + "'" + " 수정 ", "설정", principal);
                ReferenceValueSetting reference = reference_value_settingRepository.findByName(hiddenCode);
                reference.setNaming(edit_naming);
                reference_value_settingRepository.save(reference);

            }

            //측정소 변경
            if (!oldPlace.equals(place)) {
                inputLogSetting("'" + oldPlace + " - " + oldNaming + "'" + " 센서 삭제 ", "설정", principal);

                //질소산화물만 수정
                String sensorCode = hiddenCode.split("_")[1]; //-> NOX, IRS ..
                if (sensorCode.equals("NOX")) {
                    //연간 배출 모니터링 대상 수정
                    AnnualEmissions aemis = annualEmissionsRepository.findBySensor(hiddenCode);
                    aemis.setPlace(place);
                    aemis.setStatus(false);
                    annualEmissionsRepository.save(aemis);
                    inputLogSetting("'" + oldPlace + " - " + oldNaming + "'" + " 센서 연간 배출 모니터링 대상 측정소명 수정", "설정", principal);

                    //배출 모니터링 대상 수정
                    EmissionsSetting emis = emissionsSettingRepository.findBySensor(hiddenCode);
                    emis.setPlace(place);
                    emis.setStatus(false);
                    emissionsSettingRepository.save(emis);
                    inputLogSetting("'" + oldPlace + " - " + oldNaming + "'" + " 센서 배출량 추이 모니터링 대상 측정소명 수정", "설정", principal);

                    //배출 관리 기준 수정
                    EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(hiddenCode);
                    ess.setPlace(place);
                    ess.setDate(new Date());
                    emissionsStandardSettingRepository.save(ess);
                    inputLogSetting("'" + oldPlace + " - " + oldNaming + "'" + " 센서 연간 배출 허용 기준 수정", "설정", principal);
                }

                //측정소 센서 삭제
                //place 업데이트 시간 수정
                Place placeremove = placeRepository.findBySensorIsIn(hiddenCode);
                if (placeremove != null) {
                    //센서리스트에서 센서 제거
                    placeremove.getSensor().remove(hiddenCode);
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
                inputLogSetting("'" + oldPlace + " - " + oldNaming + "'" + " 센서 알림설정 값 삭제", "설정", principal);
                inputLogSetting("'" + place + " - " + oldNaming + "'" + " 센서 등록", "설정", principal);
                inputLogSetting("'" + oldNaming + "'" + " 센서의 측정소명 " + "'" + oldPlace + "'" + " > " + "'" + place + "'" + " 수정 ", "설정", principal);

                //측정소 수정할 센서를 포함하는 그룹 검색하여 센서 삭제
                groupSensorRemove(hiddenCode);
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
    public void deleteSensor(String tableName, String place, String naming, Principal principal) {

        //질소산화물만 배출 기준, 모니터링 대상 삭제
        String sensorCode = tableName.split("_")[1]; //-> NOX, IRS ..
        if (sensorCode.equals("NOX")) {
            //배출량 관리 기준 삭제
            EmissionsStandardSetting ess = emissionsStandardSettingRepository.findByTableNameIsIn(tableName);
            emissionsStandardSettingRepository.deleteByTableName(tableName);
            if (ess.getPlace().equals("")) ess.setPlace("측정소 없음");
            inputLogSetting("'" + ess.getPlace() + " - " + ess.getNaming() + "'" + " 연간 허용 배출 기준 삭제", "설정", principal);

            //배출량 관리 - 모니터링 대상 삭제
            emissionsSettingRepository.deleteBySensor(tableName);
            inputLogSetting("'" + ess.getPlace() + " - " + ess.getNaming() + "'" + " 배출량 추이 모니터링 대상 삭제", "설정", principal);

            //배출량 관리 - 연간 모니터링 대상 삭제
            annualEmissionsRepository.deleteBySensor(tableName);
            inputLogSetting("'" + ess.getPlace() + " - " + ess.getNaming() + "'" + " 연간 배출량 모니터링 대상 삭제", "설정", principal);

            //배출량 관리 - 연간 배출량 추이 삭제
            List<MonthlyEmissions> list = monthlyEmissionsRepository.findBySensor(tableName);
            for(int i=0; i<list.size(); i++){
                monthlyEmissionsRepository.deleteBySensor(tableName);
            }
            inputLogSetting("'" + ess.getPlace() + " - " + ess.getNaming() + "'" + " 연간 배출량 추이 삭제", "설정", principal);
        }

        //상세설정 값 삭제
        reference_value_settingRepository.deleteByName(tableName);
        inputLogSetting("'" + place + " - " + naming + "'" + " 관리 기준 값 삭제", "설정", principal);

        //알림설정값 삭제
        if (notification_settingsRepository.findByName(tableName) != null) {
            notification_settingsRepository.deleteByName(tableName);
            inputLogSetting("'" + place + " - " + naming + "'" + " 알림 설정값 삭제", "설정", principal);
        }

        //삭제될 센서를 포함하는 그룹 검색하여 센서 삭제
        groupSensorRemove(tableName);

        //place 업데이트 시간 수정
        if (placeRepository.findBySensorIsIn(tableName) != null) {
            Place placeObject = placeRepository.findBySensorIsIn(tableName);
            placeObject.getSensor().remove(tableName); //리스트에서 센서 제거
            placeObject.setUp_time(new Date()); //시간 업데이트
            placeRepository.save(placeObject);
        }


        //센서 삭제
        SensorList sensor = sensorListRepository.findByTableName(tableName, "");
        sensorListRepository.delete(sensor);
        inputLogSetting("'" + place + " - " + naming + "'" + " 센서 삭제", "설정", principal);
        inputLogSetting("'" + naming + "'" + " 센서 삭제", "설정", principal);


    }

    /**
     * 센서와 년도를 넣고 월별 데이터를 추출
     *
     * @param sensor   센서명
     * @param thisYear 현재년도
     * @return 올해, 작년 월별 데이터
     */
    @RequestMapping(value = "/getStatisticsData", method = RequestMethod.POST)
    public List getStatisticsData(String sensor, int thisYear) {

        MonthlyEmissions thisMe = monthlyEmissionsRepository.findBySensorAndYear(sensor, thisYear);
        MonthlyEmissions prevMe = monthlyEmissionsRepository.findBySensorAndYear(sensor, thisYear - 1);
        List monthlyList = new ArrayList();

        monthlyList.add(thisMe);
        monthlyList.add(prevMe);

        return monthlyList;
    }

    /**
     * 연간 배출량 추이 조회
     *
     * @return 연간 배출량 추이
     */
    @RequestMapping(value = "/getMonthlyEmission")
    public List<MonthlyEmissions> getMonthlyEmission() {
        List<MonthlyEmissions> data = monthlyEmissionsRepository.findAll();
        data = data.stream().sorted(Comparator.comparing(MonthlyEmissions::getYear).reversed()).collect(Collectors.toList());
        return data;
    }

    /**
     * 연간 배출량 추이 수정
     *
     * @param dList 월별 데이터
     */
    @RequestMapping(value = "/saveMEmission")
    public void saveMEmission(@RequestParam("dList[]") List<Integer> dList, Principal principal) {
        LocalDate nowDate = LocalDate.now();
        int year = nowDate.getYear();
        MonthlyEmissions data = monthlyEmissionsRepository.findByYear(dList.get(0));
        data.setJan(dList.get(1));
        data.setFeb(dList.get(2));
        data.setMar(dList.get(3));
        data.setApr(dList.get(4));
        data.setMay(dList.get(5));
        data.setJun(dList.get(6));
        data.setJul(dList.get(7));
        data.setAug(dList.get(8));
        data.setSep(dList.get(9));
        data.setOct(dList.get(10));
        data.setNov(dList.get(11));
        data.setDec(dList.get(12));
        data.setUpdateTime(new Date());
        int total = 0;
        for (int i = 1; i <= 12; i++) {
            total += dList.get(i);
        }
        String sensor = data.sensor;
        if (dList.get(0) == year) {
            AnnualEmissions annual = annualEmissionsRepository.findBySensor(sensor);
            annual.setYearlyValue(total);
            annual.setUpdateTime(new Date());
            annualEmissionsRepository.save(annual);
        }

        SensorList sensorList = sensorListRepository.findByTableName(sensor);
        inputLogSetting("'" + sensorList.place + " - " + sensorList.naming + "'" + " 센서 " + dList.get(0) + "년 연간 배출량 추이 수정", "설정", principal);
        monthlyEmissionsRepository.save(data);
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
    public void emissionsState(String sensor, boolean isCollection, Principal principal) {

        if (isCollection) {   //배출량 설정
            EmissionsSetting target = emissionsSettingRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            emissionsSettingRepository.save(target);
            String onOff = (target.isStatus() ? "ON" : "OFF");
            inputLogSetting("'" + target.getPlace() + " - " + target.getSensorNaming() + "'" + " 센서 배출량 추이 모니터링 대상 " + onOff, "설정", principal);

        } else {     //연간 배출량 설정
            AnnualEmissions target = annualEmissionsRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            annualEmissionsRepository.save(target);
            String onOff = (target.isStatus() ? "ON" : "OFF");
            inputLogSetting("'" + target.getPlace() + " - " + target.getSensorNaming() + "'" + " 센서 연간 배출량 누적 모니터링 대상 " + onOff, "설정", principal);
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
        //최초 생성시 default 그룹도 동시 생성하여 적용
        if (memberRepository.findAll().size() == 0) {
            MonitoringGroup defaultGroup = new MonitoringGroup();
            List<String> memberList = new ArrayList<>();
            List<String> placeList = new ArrayList<>();
            memberList.add(member.getId());
            placeList.add("모든 측정소");
            defaultGroup.setGroupMember(memberList);
            defaultGroup.setGroupNum(1);
            defaultGroup.setGroupName("default");
            defaultGroup.setMonitoringPlace(placeList);
            monitoringGroupRepository.save(defaultGroup);

            member.setMonitoringGroup(1);
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
     *
     * @param member 입력한 회원의 정보객체
     * @return 업데이트 성공여부
     */
    @RequestMapping(value = "/memberUpdate")
    public String memberUpdate(Member member) {
        memberService.updateMember(member);
        memberService.updateLog(member);
        return "success";
    }

    /**
     * 회원 그룹 업데이트
     *
     * @param id              멤버 아이디
     * @param monitoringGroup 모니터링그룹 명
     * @return
     */
    @RequestMapping(value = "/memberGroupUpdate")
    public String memberGroupUpdate(String id, String monitoringGroup) {
        MonitoringGroup group = monitoringGroupRepository.findByGroupName(monitoringGroup);
        int groupNum = group.getGroupNum();
        memberService.updateMemberGroup(id, groupNum);
        groupChange(id, groupNum);
        return "success";
    }

    /**
     * 그룹명 가져오기
     *
     * @param group 그룹번호
     * @return
     */
    @RequestMapping(value = "/getGroupName")
    public String getGroupName(int group) {
        return monitoringGroupRepository.findByGroupNum(group).getGroupName();
    }

    /**
     * 그룹 변경
     *
     * @param id              멤버 아이디
     * @param monitoringGroup 그룹번호
     */
    public void groupChange(String id, int monitoringGroup) {
        MonitoringGroup memberRemove = monitoringGroupRepository.findByGroupMemberIsIn(id);
        if (memberRemove != null) {
            memberRemove.getGroupMember().remove(id);
            monitoringGroupRepository.save(memberRemove);
        }
        MonitoringGroup group = monitoringGroupRepository.findByGroupNum(monitoringGroup);
        List<String> member = null;
        if (group.getGroupMember() != null) {
            member = group.getGroupMember();
            member.add(id);
        } else {
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
            if (group != null) {
                group.getGroupMember().remove(id);
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

    /**
     * 모니터링 그룹정보 가져오기
     *
     * @return
     */
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
    public String memberSignUp(String id, String iNumber, String state, String group) {
        String msg = "";
        Member newMember = memberRepository.findById(id);

        if (iNumber.equals("0")) {
            newMember.setState("5");
            msg = "가입 거절 되었습니다.";
        } else {
            //해당 그룹에 회원 추가
            MonitoringGroup monitoringGroup = monitoringGroupRepository.findByGroupNum(Integer.parseInt(group));
            List<String> groupMember;
            if (monitoringGroup.getGroupMember() == null) {
                groupMember = new ArrayList<>();
                groupMember.add(id);
            } else {
                groupMember = monitoringGroup.getGroupMember();
                groupMember.add(id);
            }
            monitoringGroup.setGroupMember(groupMember);
            monitoringGroupRepository.save(monitoringGroup);

            newMember.setMonitoringGroup(Integer.parseInt(group));
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

        //최고관리자를 변경하고, 해당 멤버가 모든 측정소가 아닐떄 모든 측정소로 변경
        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(id);
        if (value.equals("1") && group.getGroupNum() != 1) {
            List memberList = group.getGroupMember();
            memberList.remove(id);
            group.setGroupMember(memberList);
            monitoringGroupRepository.save(group);

            MonitoringGroup allGroup = monitoringGroupRepository.findByGroupNum(1);
            if (allGroup.getGroupMember() == null) {
                List memList = new ArrayList();
                memList.add(id);
                allGroup.setGroupMember(memList);
            } else {
                List allGroupMember = allGroup.getGroupMember();
                allGroupMember.add(id);
                allGroup.setGroupMember(allGroupMember);
            }

            monitoringGroupRepository.save(allGroup);
            newMember.setMonitoringGroup(1);
        }

        newMember.setState(value);
        memberRepository.save(newMember);
        return newMember.getName() + " 회원의 권한이 변경되었습니다.";
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
     *
     * @param id 제명할 유저의 id
     * @return 안내메시지 리턴
     */
    @RequestMapping(value = "/kickMember", method = RequestMethod.POST)
    public String kickMember(String id) {
        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(id);
        List memberList = group.getGroupMember();
        memberList.remove(id);
        group.setGroupMember(memberList);
        monitoringGroupRepository.save(group);


        memberRepository.deleteById(id);
        logRepository.deleteById(id);
        return "제명처리 되었습니다.";
    }

    /**
     * 변경한 권한관리 값들을 저장
     *
     * @param rankManagement 변경한 값들을 담고있는 객체
     * @return
     * @throws Exception 예외처리
     */
    @RequestMapping(value = "/rankSettingSave", method = RequestMethod.POST)
    public List<String> rankSettingSave(@RequestBody RankManagement rankManagement) throws Exception {
        RankManagement newRankManagement = rankManagementRepository.findByName(rankManagement.getName());
        List<String> stringList = new ArrayList<>();
        stringList.add((rankManagement.isDashboard() == newRankManagement.isDashboard()) ? "" : (rankManagement.isDashboard()) ? "대시보드 메뉴열람 권한부여  " : "대시보드 메뉴열람 권한해제  ");
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
     *
     * @param tableName 테이블명
     * @return 배출허용 기준치
     */
    @RequestMapping(value = "/getStandardValue", method = RequestMethod.POST)
    public EmissionsStandardSetting getStandardValue(String tableName) {
        return emissionsStandardSettingRepository.findByTableNameIsIn(tableName);
    }

    /**
     * 테이블명으로 배출기준값 리턴
     *
     * @param tableName 테이블명
     * @return 배출허용 기준치
     */
    @RequestMapping(value = "/getEmissionStandard")
    public List<EmissionsStandardSetting> getEmissionStandard() {
        return emissionsStandardSettingRepository.findAll();
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
     *
     * @param pageNo     몇페이지 인지
     * @param id         로그아이디
     * @param searchKey  검색키
     * @param searchType 검색타입
     * @return
     */
    @RequestMapping(value = "/logPagination", method = RequestMethod.POST)
    public Object logPagination(int pageNo, String id, String searchKey, String searchType) {
        if (searchKey.equals("")) searchKey = null;
        return mongoQuary.pagination(pageNo, id, searchKey, searchType);
    }


    /**
     * 검색어로 반환되는 로그데이터 Count
     *
     * @param id         로그를 구별할 id
     * @param searchKey  로그 구별할 검색어
     * @param searchType 로그 구별할 검색타입
     * @return 로그 카운트
     */
    @RequestMapping(value = "/getLogCountBySearchKey", method = RequestMethod.POST)
    public long getLogCountBySearchKey(String id, String searchKey, String searchType) {
        if (searchType.equals("type")) {
            return logRepository.countByIdAndType(id, searchKey);

        } else if (searchType.equals("content")) {
            return logRepository.countByIdAndContentLike(id, searchKey);

        } else if (searchType.equals("date")) {
            return mongoQuary.getDateCount(id, searchKey);

        }
        return 0;
    }

    /**
     * 그룹 저장, 수정
     *
     * @param name      그룹명
     * @param memList   그룹에 포함될 멤버
     * @param placeList 그룹에 포함될 측정소
     * @param flag      저장, 수정 식별키
     * @param groupNum  수정시 그룹을 식별할 키
     */
    @RequestMapping(value = "/saveGroup", method = RequestMethod.POST)
    public String saveGroup(String name, @RequestParam(value = "memList[]", required = false) List<String> memList,
                            @RequestParam(value = "placeList[]", required = false) List<String> placeList, String flag,
                            @RequestParam(value = "groupNum", required = false) int groupNum, Principal principal) {
        //중복 이름 리턴 fail
        if (monitoringGroupRepository.findByGroupName(name) != null &&
                monitoringGroupRepository.findByGroupName(name).getGroupNum() != groupNum) {
            return "fail";
        }

        MonitoringGroup group = null;
        MonitoringGroup defaultGroup = null;
        int newGroupNum;
        Member defaultMember;
        List<String> groupSensorList = new ArrayList();

        //그룹 Num +1하여 생성
        if (flag.equals("insert")) {
            group = new MonitoringGroup();
            if (monitoringGroupRepository.findTopByOrderByGroupNumDesc() != null) {
                newGroupNum = monitoringGroupRepository.findTopByOrderByGroupNumDesc().getGroupNum() + 1;
            } else {
                newGroupNum = 1;
            }
            group.setGroupNum(newGroupNum);
            group.setMonitoringPlace(placeList);

            inputLogSetting("'" + name + "'그룹 생성", "설정", principal);
            setMemberPreviousGroup(memList, group, name);

            //수정
        } else if (flag.equals("edit")) {
            group = monitoringGroupRepository.findByGroupNum(groupNum);
            groupLogPrint(name, group, placeList, memList, principal);

            //기존 회원 모두 default로 초기화 & default그룹으로 이동
            if (group.getGroupMember() != null) {
                for (int i = 0; i < group.getGroupMember().size(); i++) {
                    defaultMember = memberRepository.findById((String) group.getGroupMember().get(i));
                    defaultMember.setMonitoringGroup(1);
                    memberRepository.save(defaultMember);

                    defaultGroup = monitoringGroupRepository.findByGroupNum(1);
                    List defaultGroupMember = defaultGroup.getGroupMember();
                    defaultGroupMember.add(group.getGroupMember().get(i));
                    monitoringGroupRepository.save(defaultGroup);
                }
                group.setGroupMember(null);
                monitoringGroupRepository.save(group);
            }

            if (group.getSensor() != null && group.getSensor().size() != 0)
                groupSensorList = group.getSensor();

            if (placeList == null) {
                group.setMonitoringPlace(null);
                group.setSensor(null);
            }

            if (placeList != null && group.getSensor() != null && group.getSensor().size() != 0 && !placeList.get(0).equals("모든 측정소")) {
                //기존 그룹에서 삭제될 측정소의 센서 삭제
                for (int i = 0; i < group.getMonitoringPlace().size(); i++) {
                    if (!placeList.contains(group.getMonitoringPlace().get(i))) {
                        Place place = placeRepository.findByName((String) group.getMonitoringPlace().get(i));
                        for (int k = 0; k < place.getSensor().size(); k++) {
                            groupSensorList.remove(place.getSensor().get(k));
                        }
                    }
                }
                group.setSensor(groupSensorList);

            }
            setMemberPreviousGroup(memList, group, name);
            group.setMonitoringPlace(placeList);
        } // 수정 end

        //저장
        group.setGroupName(name);
        monitoringGroupRepository.save(group);
        return "success";
    }

    /**
     * 수정시 그룹로그 출력
     *
     * @param name      적용될 이름
     * @param group     수정할 그룹 객체
     * @param placeList 적용될 측정소 목록
     * @param memList   적용될 멤버 목록
     * @param principal log에 필요한 로그인 객체
     */
    public void groupLogPrint(String name, MonitoringGroup group, List placeList, List memList, Principal principal) {
        if (!name.equals(group.getGroupName()))
            inputLogSetting("'" + group.getGroupName() + "' -> '" + name + "'으로 그룹명 수정", "수정", principal);
        if (isEqualsList(placeList, group.getMonitoringPlace()))
            inputLogSetting("'" + group.getGroupName() + "'그룹 모니터링 측정소 수정", "수정", principal);
        if (isEqualsList(memList, group.getGroupMember()))
            inputLogSetting("'" + group.getGroupName() + "'그룹 회원목록 수정", "수정", principal);
    }

    /**
     * 그룹에 적용될 멤버 이전그룹에서 삭제 & 멤버의 그룹명 변경
     *
     * @param memList 그룹을 수정한 멤버 리스트
     * @param group   멤버들이 적용될 그룹
     * @param name    멤버들이 적용될 그룹 이름
     */
    public void setMemberPreviousGroup(List<String> memList, MonitoringGroup group, String name) {
        if (memList != null && memList.size() != 0) {
            for (int i = 0; i < memList.size(); i++) {
                //이전그룹에서 멤버 삭제
                MonitoringGroup prevGroup = monitoringGroupRepository.findByGroupMemberIsIn(memList.get(i));
                List prevGroupMember = prevGroup.getGroupMember();
                prevGroupMember.remove(memList.get(i));
                prevGroup.setGroupMember(prevGroupMember);
                monitoringGroupRepository.save(prevGroup);

                //멤버객체의 그룹 변경
                Member saveMember = memberRepository.findById(memList.get(i));
                saveMember.setMonitoringGroup(group.getGroupNum());
                memberRepository.save(saveMember);
            }
            //현재 그룹에 멤버 적용
            group.setGroupMember(memList);
        } else {
            group.setGroupMember(null);
        }
    }

    /**
     * 그룹 수정시 어떤걸 수정하는지 판별하기위해 정의한 리스트 비교 메소드
     * 두개 리스트가 null 일수도 아닐수도 있기에 조건문으로 비교
     *
     * @param list  수정될 멤버 혹은 수정될 측정소
     * @param group 그룹의 멤버 혹은 그룹의 측정소
     * @return boolean
     */
    public boolean isEqualsList(List<String> list, List<String> group) {
        if (list != null && group != null && (!list.containsAll(group) || !group.containsAll(list))) {
            return true;
        } else if (list == null && group != null) {
            return true;
        } else if (list != null && group == null) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 그룹 삭제 하면서 멤버의 그룹명도 default로 변경
     *
     * @param key 식별 키
     */
    @RequestMapping(value = "/deleteGroup", method = RequestMethod.POST)
    public void deleteGroup(int key, Principal principal) {

        MonitoringGroup group = monitoringGroupRepository.findByGroupNum(key);
        if (group.getGroupMember() != null) {
            for (int i = 0; i < group.getGroupMember().size(); i++) {
                Member saveMember = memberRepository.findById((String) group.getGroupMember().get(i));
                saveMember.setMonitoringGroup(1);
                memberRepository.save(saveMember);

                MonitoringGroup defaultGroup = monitoringGroupRepository.findByGroupNum(1);
                List defaultGroupMember = defaultGroup.getGroupMember();
                defaultGroupMember.add(group.getGroupMember().get(i));
                defaultGroup.setGroupMember(defaultGroupMember);
                monitoringGroupRepository.save(defaultGroup);
                inputLogSetting("'" + group.getGroupName() + "'그룹 삭제에 의한 '" + group.getGroupMember().get(i) + "' 유저 default 그룹으로 이동", "수정", principal);
            }
        }
        inputLogSetting("'" + group.getGroupName() + "'그룹 삭제", "삭제", principal);
        monitoringGroupRepository.delete(group);
    }

    /**
     * 그룹 생성, 수정등에 필요한 멤버, 측정소 리스트
     *
     * @return 두개를 포함한 하나의 리스트 반환
     */
    @RequestMapping(value = "/getMemberAndPlaceList", method = RequestMethod.POST)
    public List getMemberAndPlaceList() {
        List<Place> pList = placeRepository.findAll();
        List placeName = new ArrayList();
        for (int i = 0; i < pList.size(); i++) {
            placeName.add(pList.get(i).getName());
        }

        List mpList = new ArrayList();
        mpList.add(memberRepository.findAll());
        mpList.add(placeName);

        return mpList;
    }

    /**
     * 모든 측정소의 모니터링 On인 정보를 Json 형태로 가져오는 메소드
     *
     * @return jsonArray
     * [{"place": , "monitoringOn": , "monitoringOff": ,
     * "standardExist": , "standardNotExist": , "sensorList": ["센서명1","센서명2", ...],
     * "data": [{"rm05_up_time": , "rm05_status": , "rm05_beforeValue": , "rm05_value": ,
     * "rm30_up_time": , "rm30_status": , "rm30_beforeValue": , "rm30_value": ,
     * "recent_up_time": , "recent_status": , "recent_beforeValue": , "recent_value": ,
     * "legalStandard": ,"companyStandard": , "managementStandard": ,
     * "standardExistStatus": true, "naming": , "name": },{...},...]
     * },{...},...]
     */
    @RequestMapping(value = "/placeInfo", method = RequestMethod.GET)
    public JSONArray getPlaceInfo(Principal principal) {
        try {
            Map<String, List> gMS = getMonitoringSensor(principal.getName()); //사용자 권한에 해당하는 모니터링 On인 측정소, 센서 정보
            List<String> gMS_placeName = new ArrayList<>();
            for (String key : gMS.keySet()) { //key(측정소명) 추출
                gMS_placeName.add(key);
            }
            int placeListSize = gMS.size() - 2;
            JSONArray jsonArray = new JSONArray();
            for (int a = 0; a < placeListSize; a++) { //모니터링 On인 측정소
                int sensorSize = 0;
                JSONObject placeInfoList = new JSONObject();
                JSONArray placeInfoArray = new JSONArray();
                String placeName = "";
                List<String> sensorNames = new ArrayList<String>();
                placeName = gMS_placeName.get(a);
                List<String> temp = gMS.get(placeName);
                for (int b = 0; b < temp.size(); b++) {
                    sensorNames.add(temp.get(b));
                }
                List<String> sensorNameList = new ArrayList<>();
                int standardExist = 0;
                int standardNotExist = 0;
                for (int i = 0; i < sensorNames.size(); i++) { //측정소의 센서조회
                    //센서명
                    JSONObject sensorObj = new JSONObject();
                    boolean monitoring = reference_value_settingRepository.findByName(sensorNames.get(i)).getMonitoring();  //센서 모니터링 여부
                    boolean standardExistStatus = false;
                    if (monitoring) {
                        String sensorName = sensorNames.get(i);
                        String[] splitSensor = sensorName.split("_");
                        Item sensorItem = itemRepository.findByClassification(splitSensor[1]);
                        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        Sensor recentData = sensorCustomRepository.getSensorRecent(sensorNames.get(i)); //센서의 최근 데이터
                        sensorObj.put("recent_value", recentData.getValue());
                        sensorObj.put("recent_up_time", simpleDateFormat.format(recentData.getUp_time()));
                        sensorObj.put("recent_status", recentData.isStatus());
                        Sensor beforeData = sensorCustomRepository.getSensorBeforeData(sensorNames.get(i)); //센서의 이전 데이터
                        sensorObj.put("recent_beforeValue", beforeData.getValue());
                        Sensor recentDataRM05 = sensorCustomRepository.getSensorRecentRM05(sensorNames.get(i)); //센서의 최근 데이터
                        sensorObj.put("rm05_value", recentDataRM05.getValue());
                        sensorObj.put("rm05_up_time", simpleDateFormat.format(recentDataRM05.getUp_time()));
                        sensorObj.put("rm05_status", recentDataRM05.isStatus());
                        Sensor beforeDataRM05 = sensorCustomRepository.getSensorBeforeDataRM05(sensorNames.get(i)); //센서의 최근 데이터
                        sensorObj.put("rm05_beforeValue", beforeDataRM05.getValue());
                        Sensor recentDataRM30 = sensorCustomRepository.getSensorRecentRM30(sensorNames.get(i));
                        sensorObj.put("rm30_value", recentDataRM30.getValue());
                        sensorObj.put("rm30_up_time", simpleDateFormat.format(recentDataRM30.getUp_time()));
                        sensorObj.put("rm30_status", recentDataRM30.isStatus());
                        Sensor beforeDataRM30 = sensorCustomRepository.getSensorBeforeDataRM30(sensorNames.get(i)); //센서의 최근 데이터
                        sensorObj.put("rm30_beforeValue", beforeDataRM30.getValue());
                        ReferenceValueSetting sensorInfo = reference_value_settingRepository.findByName(sensorNames.get(i)); //센서의 기타 정보(기준값 등)
                        sensorObj.put("naming", sensorInfo.getNaming());
                        Object legalStandard = numberTypeChange(sensorInfo.getLegalStandard());
                        Object companyStandard = numberTypeChange(sensorInfo.getCompanyStandard());
                        Object managementStandard = numberTypeChange(sensorInfo.getManagementStandard());
                        sensorObj.put("legalStandard", legalStandard);
                        sensorObj.put("companyStandard", companyStandard);
                        sensorObj.put("managementStandard", managementStandard);
                        sensorObj.put("name", sensorNames.get(i));
                        if (sensorItem != null) {
                            sensorObj.put("unit", sensorItem.getUnit());
                        } else {
                            sensorObj.put("unit", "");
                        }
                        sensorNameList.add(sensorNames.get(i));
                        if (legalStandard.equals(999999) && companyStandard.equals(999999) && managementStandard.equals(999999)) {
                            standardNotExist += 1;
                            standardExistStatus = false;
                            sensorObj.put("standardExistStatus", standardExistStatus);
                        } else {
                            standardExist += 1;
                            standardExistStatus = true;
                            sensorObj.put("standardExistStatus", standardExistStatus);
                        }
                        placeInfoArray.add(sensorObj);
                        sensorSize += 1;
                    }
                    placeInfoList.put("standardExist", standardExist);
                    placeInfoList.put("standardNotExist", standardNotExist);
                    placeInfoList.put("data", placeInfoArray);
                }
                if (sensorSize != 0) {
                    placeInfoList.put("place", placeName);
                    placeInfoList.put("sensorList", sensorNameList);
                    placeInfoList.put("monitoringOn", sensorSize);
                    placeInfoList.put("allMonitoringOFFList", gMS.get("OffList"));
                    jsonArray.add(placeInfoList);
                }
            }
            return jsonArray;
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // memberID = 로그인 된 회원의 ID
    @RequestMapping(value = "/getMonitoringSensor", method = RequestMethod.GET)
    public LinkedHashMap<String, List> getMonitoringSensor(String memberId) {
        Member member = memberRepository.findById(memberId);
        int groupNum = member.getMonitoringGroup();

        LinkedHashMap<String, List> monitoringSensor = new LinkedHashMap<>();

        MonitoringGroup monitoringGroup = monitoringGroupRepository.findByGroupNum(groupNum);
        List<String> memberPlaceList = monitoringGroup.getMonitoringPlace();
        List<String> memberSensorList = monitoringGroup.getSensor();
        List<String> memberSensorOffList = new ArrayList<>();

        int allCount = 0;
        int allFalse = 0;

        for (String placeName : memberPlaceList) {
            Place place;
            if (placeName.equals("모든 측정소")) {
                for (Place placeList : placeRepository.findAll()) {
                    place = placeRepository.findByName(placeList.getName());
                    List<String> placeSensorList = place.getSensor();
                    List<String> sensorList = new ArrayList<>();

                    allCount += placeSensorList.size();

                    if (placeSensorList.size() != 0) {
                        for (String pSensor : placeSensorList) {
                            ReferenceValueSetting referenceValueSetting = reference_value_settingRepository.findByName(pSensor);
                            if (referenceValueSetting.getMonitoring()) {
                                sensorList.add(pSensor);
                            } else {
                                allFalse++;
                                memberSensorOffList.add(place.getName() + "-" + referenceValueSetting.getNaming());
                            }
                            monitoringSensor.put(placeList.getName(), sensorList);
                        }
                    }
                }
            } else {
                place = placeRepository.findByName(placeName);
                List<String> placeSensorList = place.getSensor();
                List<String> sensorList = new ArrayList<>();

                allCount += placeSensorList.size();

                if (placeSensorList.size() != 0) {
                    for (String pSensor : placeSensorList) {
                        for (String mSensor : memberSensorList) {
                            if (mSensor.equals(pSensor)) {
                                sensorList.add(pSensor);
                            } else {
                                ReferenceValueSetting referenceValueSetting = reference_value_settingRepository.findByName(pSensor);
                                memberSensorOffList.add(place.getName() + "-" + referenceValueSetting.getNaming());
                            }
                        }
                    }
                    if (sensorList.size() != 0) {
                        monitoringSensor.put(placeName, sensorList);
                    }
                }
            }
        }

        List<String> count = new ArrayList<>();
        if (memberPlaceList.get(0).equals("모든 측정소")) {
            count.add(String.valueOf(allFalse));
        } else {
            count.add(String.valueOf(allCount - memberSensorList.size()));
        }
        monitoringSensor.put("OFF", count);
        monitoringSensor.put("OffList", memberSensorOffList);
        return monitoringSensor;
    }

    @RequestMapping(value = "/getUnit", method = RequestMethod.GET)
    public String getUnit(String type) {
        Item item = itemRepository.findByClassification(type);
        String unit;
        try {
            unit = item.getUnit();
        } catch (NullPointerException e) {
            unit = "null";
        }
        return unit;
    }
}
