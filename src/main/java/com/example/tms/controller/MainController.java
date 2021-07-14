package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.repository.Sensor.SensorCustomRepository;
import com.example.tms.repository.SensorListRepository;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class MainController {

    final PlaceRepository placeRepository;
    final MemberRepository memberRepository;
    final EmissionsSettingRepository emissionsSettingRepository;
    final AnnualEmissionsRepository annualEmissionsRepository;
    final RankManagementRepository rankManagementRepository;
    final EmissionsStandardSettingRepository emissionsStandardSettingRepository;
    final SensorListRepository sensorListRepository;
    final MongoQuary mongoQuary;
    final LogRepository logRepository;
    final EmissionsTransitionRepository emissionsTransitionRepository;
    final ReferenceValueSettingRepository reference_value_settingRepository;
    final SensorCustomRepository sensorCustomRepository;
    final MonitoringGroupRepository monitoringGroupRepository;

    public MainController(PlaceRepository placeRepository, MonitoringGroupRepository monitoringGroupRepository, MemberRepository memberRepository, EmissionsSettingRepository emissionsSettingRepository, AnnualEmissionsRepository annualEmissionsRepository, RankManagementRepository rankManagementRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, MongoQuary mongoQuary, LogRepository logRepository, EmissionsTransitionRepository emissionsTransitionRepository, ReferenceValueSettingRepository reference_value_settingRepository, SensorCustomRepository sensorCustomRepository) {
        this.placeRepository = placeRepository;
        this.memberRepository = memberRepository;
        this.emissionsSettingRepository = emissionsSettingRepository;
        this.annualEmissionsRepository = annualEmissionsRepository;
        this.rankManagementRepository = rankManagementRepository;
        this.emissionsStandardSettingRepository = emissionsStandardSettingRepository;
        this.sensorListRepository = sensorListRepository;
        this.mongoQuary = mongoQuary;
        this.logRepository = logRepository;
        this.emissionsTransitionRepository = emissionsTransitionRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.monitoringGroupRepository = monitoringGroupRepository;
    }

    /**
     * [회원가입]
     * @return memberJoin.jsp
     */
    @RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
    public String memberJoinGet() {

        return "memberJoin";
    }

    /**
     * [로그인]
     * @return login.jsp
     */
    @RequestMapping("/login")
    public String login() {

        return "login";
    }

    /**
     * 접근하는 URL 에 접근 권한 없는 경우
     * @return accessDenied.jsp
     */
    @RequestMapping("/accessDenied")
    public String accessDenied() {

        return "accessDenied";
    }

    /**
     * [마이페이지]
     * @param principal - 로그인 유저 정보 객체
     * @param model - 현재로그인한 유저 정보객체 뷰페이지로 전달
     * @return myPage.jsp
     */
    @RequestMapping("/myPage")
    public String myPage(Principal principal,Model model){
        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);
        return "myPage";
    }

    /**
     * 현재 배출량 추이 부분 개발이 진행되지 않은 상태이기 때문에, 대시보드 화면이 의미가 없어 메인 페이지를 monitoring 페이지로 설정
     * 이후 배출량 개발이 완료되면 /dashboard 로 변경
     * @return
     */
    @RequestMapping("/")
    public String main(){

        return "redirect:monitoring";
    }

    /**
     * [대시보드]
     * @param model
     * emissionSettingList : [환경설정 - 배출량 관리] 배출량 추이 모니터링 대상 설정 되어 있는 센서 목록
     * emissionList : 모니터링 ON 되어있는 센서의 연간 배출량 추이 정보
     * sensorList : [환경설정 - 배출량 관리] - 연간 배출량 누적 모니터링 대상 설정 되어있는 센서 목록
     * placeList : 모니터링 ON 되어있는 측정소 정보 (정렬 및 중복제거)
     * standard : [환경설정 - 배출량 관리] - 연간 배출 허용 기준 설정에 등록된 해당 센서의 허용 기준치
     * member : 현재 로그인 중인 사용자 정보 (연간 배출량 누적 모니터링 > 등록하기 버튼(관리자만 보이게 하기 위함))
     *
     * @param principal 로그인 유저의 권한
     * @return dashboard.jsp
     */
    @RequestMapping("/dashboard")
    public String dashboard(Model model, Principal principal) {
        // 연간 배출량 추이 모니터링 ON
        List<EmissionsSetting> emissionsSettings = emissionsSettingRepository.findByStatus(true);
        model.addAttribute("emissionSettingList", emissionsSettings);

        List<ArrayList<EmissionsTransition>> emissionList = new ArrayList<>();
        for(int i = 0; i < emissionsSettings.size();i++){
            int year = Calendar.getInstance().get(Calendar.YEAR);
            List<EmissionsTransition> emissionsSettingList = new ArrayList<>();
            for (int j = 0; j <= 1; j++) {
                EmissionsTransition emissionsTransition = emissionsTransitionRepository.findByTableNameAndYearEquals(emissionsSettings.get(i).getSensor(),year-j);
                emissionsSettingList.add(emissionsTransition);
            }
            emissionList.add((ArrayList<EmissionsTransition>) emissionsSettingList);
        }
        model.addAttribute("emissionList", emissionList);

        List<AnnualEmissions> setting = annualEmissionsRepository.findByStatusIsTrue();
        model.addAttribute("sensorList",setting);

        List<String> placeList = new ArrayList<>();
        for (AnnualEmissions place : setting) {
            placeList.add(place.getPlace());
        }
        TreeSet<String> placeSet = new TreeSet<>(placeList);
        model.addAttribute("placeList", placeSet);

        List<EmissionsStandardSetting> standard = new ArrayList<>();
        for (int i = 0; i<setting.size(); i++){
            standard.add(emissionsStandardSettingRepository.findByTableNameIsIn(setting.get(i).getSensor()));
        }
        model.addAttribute("standard",standard);

        if(principal == null){
            return "redirect:logout";
        }
        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);

        return "dashboard";
    }

    /**
     * [알림]
     * @return alarm.jsp
     */
    @RequestMapping("/alarm")
    public String alarm() {

        return "alarm";
    }

    /**
     * [모니터링 - 실시간 모니터링]
     * @param model
     * place - 모니터링 True 인 측정소 리스트
     * sensor - 위 측정소 리스트에 해당하는 모니터링 True 인 센서 리스트(최근,이전,기준값 등)
     */
    @RequestMapping("/monitoring")
    public void monitoring(Model model) {
        try{
            JSONArray jsonArray = new JSONArray();
            //모니터링 페이지에서 전체 측정소의 jsonarray2(센서들의 정보(최근,이전,기준값 등)들)을 JSON 타입으로 저장하기 위한 변수
            List<String> placeNames = new ArrayList<>();
            // 모니터링 True 인 측정소명을 저장하기 위한 변수
            List<Place> placeList = placeRepository.findByMonitoringIsTrue(); //측정소 모니터링 True인 측정소리스트
            for(int z=0; z<placeList.size(); z++){
                placeNames.add(placeList.get(z).getName()); //측정소명만 추출하여 저장
                List<String> sensorNames = placeRepository.findByName(placeNames.get(z)).getSensor(); //측정소의 센서들
                JSONArray jsonArray2 = new JSONArray();
                // 모니터링 True 인 센서들의 정보(최근,이전,기준값 등) JSON 타입으로 저장하기 위한 변수
                for(int i=0; i<sensorNames.size(); i++){
                    JSONObject subObj = new JSONObject();
                    //센서의 정보들(최근, 이전, 기준값)을 JSON 타입으로 저장하기 위한 변수
                    boolean monitoring = reference_value_settingRepository.findByName(sensorNames.get(i)).getMonitoring();  //센서 모니터링 여부
                    if(monitoring){
                        try{
                            subObj.put("place", placeNames.get(z));
                            Sensor recentData = sensorCustomRepository.getSensorRecent(sensorNames.get(i)); //센서의 최근 데이터
                            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            subObj.put("value", recentData.getValue());
                            subObj.put("up_time", simpleDateFormat.format(recentData.getUp_time()));
                            subObj.put("status", recentData.isStatus());
                        }catch (Exception e){
                            System.out.println("error");
                        }
                        try {
                            Sensor beforeData = sensorCustomRepository.getSensorBeforeData(sensorNames.get(i)); //센서의 이전 데이터
                            subObj.put("beforeValue", beforeData.getValue());
                        }catch (Exception e){
                            subObj.put("beforeValue", 0);
                        }
                        try{
                            Sensor recentDataRM05 = sensorCustomRepository.getSensorRecentRM05(sensorNames.get(i)); //센서의 최근 데이터
                            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            subObj.put("rm05_value", recentDataRM05.getValue());
                            subObj.put("rm05_up_time", simpleDateFormat.format(recentDataRM05.getUp_time()));
                            subObj.put("rm05_status", recentDataRM05.isStatus());
                        }catch (Exception e){
                            System.out.println("error");
                        }
                        try{
                            Sensor beforeDataRM05 = sensorCustomRepository.getSensorBeforeDataRM05(sensorNames.get(i)); //센서의 최근 데이터
                            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            subObj.put("rm05_beforeValue", beforeDataRM05.getValue());
                        }catch (Exception e){
                            System.out.println("error");
                        }
                        try{
                            Sensor recentDataRM30 = sensorCustomRepository.getSensorRecentRM30(sensorNames.get(i)); //센서의 최근 데이터
                            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            subObj.put("rm30_value", recentDataRM30.getValue());
                            subObj.put("rm30_up_time", simpleDateFormat.format(recentDataRM30.getUp_time()));
                            subObj.put("rm30_status", recentDataRM30.isStatus());
                        }catch (Exception e){
                            System.out.println("error");
                        }
                        try{
                            Sensor beforeDataRM30 = sensorCustomRepository.getSensorBeforeDataRM30(sensorNames.get(i)); //센서의 최근 데이터
                            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            subObj.put("rm30_beforeValue", beforeDataRM30.getValue());
                        }catch (Exception e){
                            System.out.println("error");
                        }
                        ReferenceValueSetting sensorInfo = reference_value_settingRepository.findByName(sensorNames.get(i)); //센서의 기타 정보(기준값 등)
                        subObj.put("naming", sensorInfo.getNaming());
                        subObj.put("legalStandard", numberTypeChange(sensorInfo.getLegalStandard()));
                        subObj.put("companyStandard", numberTypeChange(sensorInfo.getCompanyStandard()));
                        subObj.put("managementStandard", numberTypeChange(sensorInfo.getManagementStandard()));
                        subObj.put("name", sensorNames.get(i));
                        jsonArray2.add(subObj);
                    }
                }
                jsonArray.add(jsonArray2);
            }
            model.addAttribute("place", placeNames); //측정소 목록
            model.addAttribute("sensor", jsonArray); //전체 측정소의 센서 정보들
        }catch (Exception e){
            System.out.println("error");
        }
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
     * [모니터링 - 상세화면]
     * @param sensor @RequestParam 센서
     * @param model
     */
    @RequestMapping(value = "/sensor", method = RequestMethod.GET)
    public void sensorInfo(@RequestParam(required = false, defaultValue = "", value = "sensor") String sensor, Model model) {
        try{
            JSONArray jsonArray = new JSONArray();
            //모니터링 페이지에서 선택된 측정소의 센서들의 정보(최근,이전,기준값 등)들을 JSON 타입으로 저장하기위한 변수
            JSONArray jsonArray2 = new JSONArray();
            // 선택된 센서의 최근 1시간 데이터들을 JSON 타입으로 저장하기 위한 변수
            List<String> placeNames = new ArrayList<>();
            // 모니터링 True 인 측정소명을 저장하기 위한 변수

            List<Place> placeList = placeRepository.findByMonitoringIsTrue(); //측정소 모니터링 True인 측정소 정보
            String placeName = "";
            for(int z=0; z<placeList.size(); z++){
                placeNames.add(placeList.get(z).getName()); //측정소 리스트에서 측정소명만 추출하여 저장
                if(sensor.equals("")){ //파라미터가 없을 경우
                    placeName = placeList.get(0).getName(); //0번째 측정소명을 default 로 설정
                }else{ //파라미터가 있을 경우
                    placeName = placeRepository.findBySensorIsIn(sensor).getName(); //해당 파라미터의 센서에 해당하는 측정소명
                }
            }
            List<String> sensorNames = placeRepository.findByName(placeName).getSensor(); //측정소의 센서명 저장
            for(int i=0; i<sensorNames.size(); i++){
                JSONObject subObj = new JSONObject();
                //센서의 정보들(최근, 이전, 기준값)을 JSON 타입으로 저장하기 위한 변수
                boolean monitoring = reference_value_settingRepository.findByName(sensorNames.get(i)).getMonitoring(); //센서 모니터링 여부
                if(monitoring){ //센서 모니터링 True
                    String sensorName = sensorNames.get(i);
                    try{
                        Sensor recentData = sensorCustomRepository.getSensorRecent(sensorName); //센서의 최근 데이터
                        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        subObj.put("value", numberTypeChange(recentData.getValue()));
                        subObj.put("up_time", simpleDateFormat.format(recentData.getUp_time()));
                        subObj.put("status", recentData.isStatus());
                    }catch (Exception e){
                        System.out.println("error");
                    }
                    try {
                        Sensor beforeData = sensorCustomRepository.getSensorBeforeData(sensorName); //센서의 이전 데이터
                        subObj.put("beforeValue", numberTypeChange(beforeData.getValue()));
                    }catch (Exception e){
                        subObj.put("beforeValue", 0);
                    }
                    ReferenceValueSetting sensorInfo = reference_value_settingRepository.findByName(sensorName); //센서의 기타 정보(기준값 등)
                    subObj.put("naming", sensorInfo.getNaming());
                    subObj.put("legalStandard", numberTypeChange(sensorInfo.getLegalStandard()));
                    subObj.put("companyStandard", numberTypeChange(sensorInfo.getCompanyStandard()));
                    subObj.put("managementStandard", numberTypeChange(sensorInfo.getManagementStandard()));
                    subObj.put("name", sensorName);
                    jsonArray.add(subObj);
                    if(sensorName.equals(sensor)){ //파라미터와 센서명이 일치할 경우
                        model.addAttribute("activeSensor", subObj); //선택된 센서 데이터
                    }else if(sensor.equals("") && i == 0){ //파라미터가 없을 경우
                        model.addAttribute("activeSensor", subObj); //0번째 센서 데이터
                    }
                }
            }
            List<Sensor> sensorData = new ArrayList<>();
            // 센서의 최근 데이터들을 저장하기 위한 변수
            if(sensor.equals("")){ //파라미터가 없을 경우
                sensorData = sensorCustomRepository.getSenor(sensorNames.get(0),"1");
            }else{ //파라미터가 있을 경우
                sensorData = sensorCustomRepository.getSenor(sensor, "1");
            }
            for(int i=0; i<sensorData.size(); i++){
                JSONObject subObj2 = new JSONObject();
                //해당 센서의 최근 1시간 데이터들을 JSON 타입으로 차트 생성에 필요한 변수 x, y로 저장
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                subObj2.put("y", numberTypeChange(sensorData.get(i).getValue()));
                subObj2.put("x",  simpleDateFormat.format(sensorData.get(i).getUp_time()));
                jsonArray2.add(subObj2);
            }
            model.addAttribute("activePlace", placeName); // 선택된 측정소
            model.addAttribute("placeList", placeNames); //모니터링 Ture 인 측정소 리스트
            model.addAttribute("sensor", jsonArray); //선택된 측정소의 센서 테이블
            model.addAttribute("sensorData", jsonArray2); //선택된 센서의 최근 1시간 데이터
        }catch (Exception e){
            System.out.println("error");
        }

    }

    /**
     * [분석 및 통계 - 측정자료 조회]
     * @param model 등록된 센서가 있는 측정소 정보
     * @return dataInquiry.jsp
     */
    @RequestMapping("/dataInquiry")
    public String dataInquiry(Model model) {

        model.addAttribute("place", mongoQuary.findPlaceSensorNotEmpty());

        return "dataInquiry";
    }

    /**
     * [분석 및 통계 - 통계자료 조회]
     * @param model 등록된 센서가 있는 측정소 정보
     * @return dataStatistics.jsp
     */
    @RequestMapping("/dataStatistics")
    public String statistics(Model model) {

        model.addAttribute("place", mongoQuary.findPlaceSensorNotEmpty());

        return "dataStatistics";
    }

    /**
     *  [환경설정 - 측정소 관리]
     * @param principal 해당 페이지에 접근하는 멤버 객체
     * @param model 멤버의 등급, 멤버가 속한 그룹의 측정 가능한 측정소
     * @return stationManagement.JSP
     */
    @RequestMapping("/stationManagement")
    public String stationManagement(Principal principal, Model model) {

        Member member =  memberRepository.findById(principal.getName());
        model.addAttribute("state", member.getState());

        MonitoringGroup group = monitoringGroupRepository.findByGroupMemberIsIn(member.getId());
        List<String> placeList = new ArrayList();
        if(group.getGroupName().equals("default") || group.getMonitoringPlace() == null){
            placeList.add("null");
        }else {
            for (int i = 0; i < group.getMonitoringPlace().size(); i++)
                placeList.add("'" + group.getMonitoringPlace().get(i) + "'");
        }
        model.addAttribute("groupPlace", placeList);

        return "stationManagement";
    }

    /**
     * [환경설정 - 센서 관리]
     * @param model
     * collections : lghausys_xxx_xxx 형식으로 등록된 Collections 정보 리스트 (현재 등록된 센서 정보와 비교하여 중복제거 해서 리턴)
     * place : 등록된 모든 측정소 정보
     * @return sensorManagement.jsp
     */
    @RequestMapping("/sensorManagement")
    public String sensorManagement(Model model) {
        List<String> result = mongoQuary.getCollection();
        for(SensorList sensorList : sensorListRepository.findAll()){
            for(String tableName : mongoQuary.getCollection()){
                if(tableName.equals(sensorList.getTableName())){
                    result.remove(tableName);
                }
            }
        }
        model.addAttribute("collections", result);
        model.addAttribute("place", placeRepository.findAll());

        return "sensorManagement";
    }

    /**
     * [환경설정 - 알림 설정]
     * @param model
     * place : 등록된 모든 측정소중 모니터링 True
     * @return alarmManagement.jsp
     */
    @RequestMapping(value = "/alarmManagement")
    public String alarmManagement(Model model) {
        List<Place> placeList = placeRepository.findByMonitoringIsTrue();
        for (int i =0; i<placeList.size(); i++){
            if (placeList.get(i).getSensor().size() == 0)
                placeList.remove(i);
        }
        model.addAttribute("place", placeList);

        return "alarmManagement";
    }

    /**
     *  [환경설정 - 배출량 관리]
     * @param model
     * standard : 연간 배출 허용 기준 설정 list
     * emissions : 배출량 추이 모니터링 대상 설정 list
     * yearlyEmissions : 연간 배출량 누적 모니터링 대상 설정 list
     * @return emissionsManagement.jsp
     * */
    @RequestMapping("emissionsManagement")
    public String emissionsManagement(Model model) {
        //측정소 없으면 제외
        model.addAttribute("emissions", emissionsSettingRepository.findByPlaceIsNotIn(""));
        model.addAttribute("yearlyEmissions", annualEmissionsRepository.findByPlaceIsNotIn(""));
        model.addAttribute("standard",emissionsStandardSettingRepository.findAll());

        return "emissionsManagement";
    }

    /**
     * [환경설정 - 설정]
     * @param model
     * members : 전체 회원 정보
     * member : 현재 로그인 되어있는 회원
     * rank_managements : 권한 정보
     * @param principal 로그인 유저 정보 객체
     * @return setting.jsp
     */
    @RequestMapping("/setting")
    public String setting(Model model, Principal principal) {
        List<Member> members = memberRepository.findAll();
        List<RankManagement> rank_managements = rankManagementRepository.findAll();
        Member member = memberRepository.findById(principal.getName());
        List<MonitoringGroup> group = monitoringGroupRepository.findAll();
        List<Place> place = placeRepository.findAll();

        model.addAttribute("member", member);
        model.addAttribute("members", members);
        model.addAttribute("rank_managements", rank_managements);
        model.addAttribute("group", group);
        model.addAttribute("place", place);
        return "setting";
    }

    /**
     * [환경설정 - 설정] > 회원관리 (회원 정보 클릭 시)
     * @param model
     * logList : 해당 유저의 전체 log
     * member : 해당 유저의 이름 및 권한 불러오기
     * @param id 로그 조회할 Id
     * @return log.jsp
     */
    @RequestMapping("log")
    public String log(Model model, @RequestParam(value = "id",required = false) String id) {

        //페이징 처리 하기위한 전체 count
        model.addAttribute("count",logRepository.countById(id));
        model.addAttribute("logList",mongoQuary.pagination(1, id,null,null));
        model.addAttribute("member",memberRepository.findById(id));
        return "log";
    }

}