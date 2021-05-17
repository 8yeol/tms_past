package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.service.RankManagementService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.*;

@Controller
public class MainController {

    final PlaceRepository placeRepository;
    final MemberRepository memberRepository;
    final EmissionsSettingRepository emissionsSettingRepository;
    final AnnualEmissionsRepository annualEmissionsRepository;
    final RankManagementRepository rank_managementRepository;
    final EmissionsStandardSettingRepository emissionsStandardSettingRepository;
    final SensorListRepository sensorListRepository;
    final MongoQuary mongoQuary;
    final LogRepository logRepository;
    final placeTotalMonitoringRepository placeTotalMonitoringRepository;

    final RankManagementService rankManagementService;

    public MainController(PlaceRepository placeRepository, MemberRepository memberRepository, EmissionsSettingRepository emissionsSettingRepository,
                          AnnualEmissionsRepository annualEmissionsRepository, RankManagementRepository rank_managementRepository,
                          EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository,
                          LogRepository logRepository, placeTotalMonitoringRepository placeTotalMonitoringRepository,RankManagementService rankManagementService,MongoQuary mongoQuary)
    {
        this.placeRepository = placeRepository;
        this.memberRepository = memberRepository;
        this.emissionsSettingRepository = emissionsSettingRepository;
        this.annualEmissionsRepository = annualEmissionsRepository;
        this.rank_managementRepository = rank_managementRepository;
        this.emissionsStandardSettingRepository = emissionsStandardSettingRepository;
        this.sensorListRepository = sensorListRepository;
        this.mongoQuary = mongoQuary;
        this.logRepository = logRepository;
        this.rankManagementService = rankManagementService;
        this.placeTotalMonitoringRepository = placeTotalMonitoringRepository;
    }


    /**
     *
     * @param model
     * - sensorList - 연간 배출량 누적 모니터링 대상 센서중 관리자가 선택한 센서만 가져오기
     * - placeList - sensorList의 측정소를 중복제거,정렬한 값
     * - standard - 연간 배출 허용 기준치 가져오기
     * - ptmsList
     * - member
     * @param principal
     * @return DashBoard.JSP
     */
    @RequestMapping("/")
    public String dashboard(Model model,Principal principal) {

        //선택된 센서 (findByStatusIsTrue) 가져오기
        List<AnnualEmissions> setting = annualEmissionsRepository.findByStatusIsTrue();
        model.addAttribute("sensorList",setting);

        //선택된 센서 측정소 중복제거  List -> Set
        List<String> placelist = new ArrayList<>();
        for (AnnualEmissions place : setting) {
            placelist.add(place.getPlace());
        }
        TreeSet<String> placeSet = new TreeSet<>(placelist);
        model.addAttribute("placeList", placeSet);


        /*연간 배출기준값 가져오기*/
        List<EmissionsStandardSetting> standard = emissionsStandardSettingRepository.findAll();
        model.addAttribute("standard",standard);

        //모니터링 대상에 선택된 값들 찾기
        List<EmissionsSetting> emissionsSettings = emissionsSettingRepository.findByStatus(true);
        //model에 넣어줄 리스트타입의 리스트변수
        List<ArrayList<placeTotalMonitoring>> ptmsList = new ArrayList<>();
        //선택된 값들의 년도별 total값들 리스트에 넣어주기
        //for(int i = 0; i < emissionsSettings.size();i++){
        for(int i = 0; i < 1;i++){
            //EmissionsSetting emissionsSetting = emissionsSettings.get(i);
            //List<placeTotalMonitoring> ptms = placeTotalMonitoringRepository.findByTableNameOrderByYearDesc(emissionsSetting.getSensor());
            List<placeTotalMonitoring> ptms = placeTotalMonitoringRepository.findByTableNameOrderByYearDesc("lghausys_NOX_001");
            if(ptms.size() > 0){
                ptmsList.add((ArrayList<placeTotalMonitoring>) ptms);
            }
        }
        model.addAttribute("ptmsList", ptmsList);

        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);


        return "dashboard";
    }

    @RequestMapping("/login")
    public String login() {
        return "login";
    }
    @RequestMapping("/accessDenied")
    public String accessDenied() {
        return "accessDenied";
    }
    @RequestMapping("/myPage")
    public String myPage(Principal principal,Model model){
        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);
        return "myPage";
    }

    @RequestMapping("/monitoring")
    public void monitoring() {
    }

    @RequestMapping(value = "/sensor", method = RequestMethod.GET)
    public void sensorInfo(Model model) {
        model.addAttribute("place", placeRepository.findAll());
    }

    @RequestMapping("/alarm")
    public String alarm() {
        return "alarm";
    }

    /**
     * 로그 페이지로 이동
     * @param model 로그 리스트를 들고갑니다.
     * @return log.JSP
     */
    @RequestMapping("/log")
    public String log(Model model) {
        List logList= logRepository.findAll();
        model.addAttribute("logList",logList);

        return "log";
    }

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


        List<Place> places = placeRepository.findAll();

        List<String> placelist = new ArrayList<>();
        for (Place place : places) {
            placelist.add(place.getName());
        }

        model.addAttribute("place", placelist);


        return "sensorManagement";
    }

    @RequestMapping("/alarmSetting")
    public String alarmSetting() {
        return "alarmSetting";
    }

    @RequestMapping("/setting")
    public String setting(Model model,Principal principal) {
        List<Member> members = memberRepository.findAll();
        List<RankManagement> rank_managements = rank_managementRepository.findAll();
        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);
        model.addAttribute("members", members);
        model.addAttribute("rank_managements", rank_managements);
        return "setting";
    }

    @RequestMapping("/dataStatistics")
    public String statistics(Model model) {

        model.addAttribute("place", mongoQuary.findPlaceSensorNotEmpty());

        return "dataStatistics";
    }

    @RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
    public String memberJoinGet() {
        return "memberJoin";
    }

    @RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
    @ResponseBody
    public void memberJoinPost(@RequestBody Member member, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();

        if(memberRepository.findAll().size() == 0){ // 최초회원가입시
            member.setState("4"); // 최고관리자 설정
            memberRepository.save(member);
            rankManagementService.defaultRankSetting();
            out.print("root");
        } else if (!memberRepository.existsById(member.getId())) {
            member.setState("1"); // 0: 거절 - 1: 가입대기 - 2: 일반 - 3: 관리자 - 4: 최고관리자
            memberRepository.save(member);
            out.print("true");
        } else {
            out.print("false");
        }
    }           // memberJoinPost

    @RequestMapping(value = "/memberUpdate", method = RequestMethod.POST)
    @ResponseBody
    public void memberUpdate(@RequestBody Member member, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        Member newMember = memberRepository.findById(member.getId());
        if( !(member.getPassword().equals(newMember.getPassword())) ) {// 들어온 pwd 값과 DB pwd 값이 같지않으면
            out.print("false");
        } else{
            newMember.setName(member.getName());
            newMember.setEmail(member.getEmail());
            newMember.setTel(member.getTel());
            newMember.setDepartment(member.getDepartment());
            newMember.setGrade(member.getGrade());
            memberRepository.save(newMember);
            out.print("true");
        }
    }           // memberUpdate

    @RequestMapping(value = "/loginCheck", method = RequestMethod.POST)
    public void loginCheck( Member member, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        if(!memberRepository.existsById(member.getId())){ // ID가 존재하지않으면
            out.print("id");
        } else if(!memberRepository.findById(member.getId()).getPassword().equals(member.getPassword())){ // password가 틀리면
            out.print("password");
        } else { // 로그인성공
            Member newMember = memberRepository.findById(member.getId());
            Date time = new Date();
            newMember.setLastLogin(time);
            memberRepository.save(newMember);
        }
    }           // loginCheck


    @RequestMapping(value = "/signUp", method = RequestMethod.POST)
    public @ResponseBody String memberSignUp(String id, String iNumber){
        String msg = "";
        Member newMember = memberRepository.findById(id);
        if(iNumber.equals("0")){
            newMember.setState("0");
            msg = "가입 거절 되었습니다.";
        }else{
            newMember.setState("2"); // 0: 거절 - 1: 가입대기 - 2: 일반 - 3: 관리자 - 4: 최고관리자
            Date time = new Date();
            newMember.setJoined(time); // 가입승인일 설정
            msg = "가입 승인 되었습니다.";
        }
        memberRepository.save(newMember);
        return msg;
    }           // memberSignUp

    @RequestMapping(value = "/gaveRank", method = RequestMethod.POST)
    public @ResponseBody String gaveRank(String id, String value){
        Member newMember = memberRepository.findById(id);
        newMember.setState(value);
        memberRepository.save(newMember);
        return "등급 부여 하였습니다.";
    }           // gaveRank

    @RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
    public @ResponseBody String resetPassword(String id){
        Member newMember = memberRepository.findById(id);
        String uuid = (UUID.randomUUID().toString().replaceAll("-", "")).substring(0,10);
        newMember.setPassword(uuid);
        memberRepository.save(newMember);
        return "비밀번호가 초기화 되었습니다. \n임시비밀번호 : "+ uuid;
    }           // resetPassword

    @RequestMapping(value = "/kickMember", method = RequestMethod.POST)
    public @ResponseBody String kickMember(String id){
        memberRepository.deleteById(id);
        return "추방처리 되었습니다.";
    }           // kickMember


    @RequestMapping(value = "/rankSettingSave", method = RequestMethod.POST)
    @ResponseBody
    public void rankSettingSave(@RequestBody RankManagement rankManagement, HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        RankManagement newRankManagement = rank_managementRepository.findByName(rankManagement.getName());

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
        rank_managementRepository.save(newRankManagement);
    }           // rankSettingSave

    @RequestMapping(value = "/inputLog", method = RequestMethod.POST)
    @ResponseBody
    public void inputLog(@RequestBody Log log){
        log.setDate(new Date());
        logRepository.save(log);
    }           // inputLog


    @RequestMapping(value = "/InputPlaceTotalMonitoring", method = RequestMethod.POST)
    @ResponseBody
    public void InputPlaceTotalMonitoring(@RequestBody placeTotalMonitoring placeTotalMonitoring) {
        placeTotalMonitoringRepository.save(placeTotalMonitoring);
    }           // InputPlaceTotalMonitoring

    @RequestMapping(value = "/getUsername", method = RequestMethod.POST)
    @ResponseBody
    public String getUsername(Principal principal) {
        Member member = memberRepository.findById(principal.getName());
        return member.getName();
    }           // getUsername


    @RequestMapping("/dataInquiry")
    public String dataInquiry(Model model) {

        model.addAttribute("place", mongoQuary.findPlaceSensorNotEmpty());

        return "dataInquiry";
    }

// =====================================================================================================================
// 알림 설정페이지 (ppt-8페이지)
// param # key : String place (place.name)
// =====================================================================================================================

    @RequestMapping(value = "/alarmManagement")
    public String alarmManagement(Model model) {
        List<Place> places = placeRepository.findAll();
        List<String> placelist = new ArrayList<>();

        for (Place place : places) {
            placelist.add(place.getName());
        }

        model.addAttribute("place", placelist);

        return "alarmManagement";
    }

    // =====================================================================================================================
// 측정소 관리페이지 (ppt-9페이지)
//
// =====================================================================================================================
    @RequestMapping("/stationManagement")
    public String stationManagement() {
        return "stationManagement";
    }


    /**
     *  데이터 검색후  배출량 관리 페이지에 접근
     * @param model
     * 연간배출 허용기준 - standard
     * 배출량 추이 모니터링 대상 - emissions
     * 연간 배출량 누적 모니터링 대상 - yearlyEmissions
     * @return emissionsManagement.JSP
     * */
    @RequestMapping("emissionsManagement")
    public String emissionsManagement(Model model) {

        List<EmissionsSetting> emissions = emissionsSettingRepository.findAll();
        for (int i = 0 ; i<emissions.size(); i++){
            if(emissions.get(i).getPlace().equals("") || emissions.get(i).getPlace() == null){        //측정소 없으면 제외
                emissions.remove(i);
                i--;
            }
        }
        model.addAttribute("emissions", emissions);


        List<AnnualEmissions> yearlyEmissions = annualEmissionsRepository.findAll();
        for (int i = 0 ; i< yearlyEmissions.size(); i++) {
            if (yearlyEmissions.get(i).getPlace().equals("") || yearlyEmissions.get(i).getPlace() == null) {   //측정소 없으면 제외
                yearlyEmissions.remove(i);
                i--;
            }
        }
        model.addAttribute("yearlyEmissions", yearlyEmissions);

        List<EmissionsStandardSetting> standard =  emissionsStandardSettingRepository.findAll();
        model.addAttribute("standard",standard);

        return "emissionsManagement";
    }


    /**
     * 배출량 모니터링 상태값을 변경
     * @param sensor 상태값 변경할 센서
     * @param isCollection 배출량 추이 모니터링 <->연간 배출량 누적 모니터링   판별할 데이터
     */
    @ResponseBody
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


}
