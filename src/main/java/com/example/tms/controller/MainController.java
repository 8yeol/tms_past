package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.service.MemberService;
import com.example.tms.service.RankManagementService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
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
    final RankManagementService rankManagementService;
    final MemberService memberService;
    final PasswordEncoder passwordEncoder;

    public MainController(PlaceRepository placeRepository, MemberRepository memberRepository, EmissionsSettingRepository emissionsSettingRepository, AnnualEmissionsRepository annualEmissionsRepository, RankManagementRepository rankManagementRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, MongoQuary mongoQuary, LogRepository logRepository, EmissionsTransitionRepository emissionsTransitionRepository, RankManagementService rankManagementService, MemberService memberService, PasswordEncoder passwordEncoder) {
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
        this.rankManagementService = rankManagementService;
        this.memberService = memberService;
        this.passwordEncoder = passwordEncoder;
    }

    @RequestMapping("/")
    public String main(){
        return "redirect:monitoring";
    }

    /**
     *
     * @param model
     * - sensorList - 연간 배출량 누적 모니터링 대상 센서중 관리자가 선택한 센서만 가져오기
     * - placeList - sensorList의 측정소를 중복제거,정렬한 값
     * - standard - 연간 배출 허용 기준치 가져오기
     * - ptmsList - 연간배출량 데이터들을 Model 로넘겨주기위한 List 변수
     * - member - 현재 로그인중인 사용자의 정보 객체
     * @param principal
     * @return DashBoard.JSP
     */
    @RequestMapping("/dashboard")
    public String dashboard(Model model,Principal principal) {
        // 연간 배출량 추이 모니터링
        // [환경설정 > 배출량 관리] - 배출량 추이 모니터링 대상 설정 ON 되어있는 센서 정보
        List<EmissionsSetting> emissionsSettings = emissionsSettingRepository.findByStatus(true);
        model.addAttribute("emissionSettingList", emissionsSettings);

        // 모니터링 ON 되어있는 센서의 연간 배출량 추이 정보
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

        // 연간 배출량 누적 모니터링
        // [환경설정 > 배출량 관리] - 연간 배출량 누적 모니터링 대상 설정 ON
        List<AnnualEmissions> setting = annualEmissionsRepository.findByStatusIsTrue();
        model.addAttribute("sensorList",setting);
        // 모니터링 On 설정된 센서가 포함되어있는 측정소(측정소 중복제거)
        List<String> placeList = new ArrayList<>();
        for (AnnualEmissions place : setting) {
            placeList.add(place.getPlace());
        }
        TreeSet<String> placeSet = new TreeSet<>(placeList);
        model.addAttribute("placeList", placeSet);
        // [환경설정 > 배출량 관리] - 배출 허용 기준 설정에 설정된 기준값 > 모니터링 설정된 배출량 기준값만 받아오도록 변경
        List<EmissionsStandardSetting> standard = emissionsStandardSettingRepository.findAll();
        model.addAttribute("standard",standard);
        // 연간 배출량 누적 모니터링 > 등록하기 버튼(관리자만 보이게 하기 위함)
        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);

        return "dashboard";
    }

    @RequestMapping("/login")
    public String login() {
        return "login";
    }       //login

    /**
     * 접근하는 URL에 권한이없을시 오는 페이지
     * @return accessDenied.jsp
     */
    @RequestMapping("/accessDenied")
    public String accessDenied() {
        return "accessDenied";
    }       //accessDenied
    /**
     * 마이페이지로 이동
     * @param principal - 로그인 유저 정보 객체
     * @param model - principal을 기준으로 member객체를 add함
     * @return myPage.jsp
     */
    @RequestMapping("/myPage")
    public String myPage(Principal principal,Model model){
        Member member = memberRepository.findById(principal.getName());
        model.addAttribute("member", member);
        return "myPage";
    }       //myPage
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
     * 원하는 id 있을시 id에대한 로그정보만 출력
     * @param model 로그 리스트를 들고갑니다.
     * @return log.JSP
     */
    @RequestMapping("/log")
    public String log(Model model,@RequestParam(value = "id", required = false) String id) {

        if(id==null) {
            List logList = logRepository.findAll();
            model.addAttribute("logList", logList);
            Member member = new Member();
            member.setId("All");
            model.addAttribute("member",member);

        }else{
            List logList = logRepository.findById(id);
            model.addAttribute("logList", logList);
            Member member = memberRepository.findById(id);
            model.addAttribute("member",member);
        }
        return "log";
    }
    /**
     * 센서, 측정소 데이터들고 환경설정 - 센서관리 이동
     * @param model
     * - collections - 생성하지않은 센서리스트
     * - place - 모든 측정소
     * @return sensorManagement.JSP
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

        List<Place> places = placeRepository.findAll();
        model.addAttribute("place", places);

        return "sensorManagement";
    }
    @RequestMapping("/alarmSetting")
    public String alarmSetting() {
        return "alarmSetting";
    }
    /**
     * 환경설정 - 설정 페이지로 이동
     * @param model - 회원목록, 로그인한회원, 관리할 등급데이터 들을 add
     * @param principal - 로그인 유저 정보 객체
     * @return setting.jsp
     */
    @RequestMapping("/setting")
    public String setting(Model model,Principal principal) {
        List<Member> members = memberRepository.findAll();
        List<RankManagement> rank_managements = rankManagementRepository.findAll();
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
    /**
     * 회원가입페이지로 이동
     * @return memberJoin.jsp
     */
    @RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
    public String memberJoinGet() {
        return "memberJoin";
    }

    /**
     * 분석 및 통계 - 측정 자료 조회
     * @param model 측정소와 센서
     * @return dataInquiry.JSP
     */
    @RequestMapping("/dataInquiry")
    public String dataInquiry(Model model) {

        model.addAttribute("place", mongoQuary.findPlaceSensorNotEmpty());

        return "dataInquiry";
    }
    /**
     * 알림 설정페이지 (ppt-8페이지)
     * @param model - 측정소명
     * @return alarmManagement.JSP
     */
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
    /**
     * 측정소 관리 페이지
     * @return stationManagement.JSP
     */
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
     *
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



}