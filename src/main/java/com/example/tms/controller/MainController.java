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
    final EmissionsTransitionRepository emissionsTransitionRepository;
    final RankManagementService rankManagementService;
    final MemberService memberService;
    final PasswordEncoder passwordEncoder;

    public MainController(PlaceRepository placeRepository, MemberRepository memberRepository, EmissionsSettingRepository emissionsSettingRepository, AnnualEmissionsRepository annualEmissionsRepository, RankManagementRepository rank_managementRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, MongoQuary mongoQuary, LogRepository logRepository, EmissionsTransitionRepository emissionsTransitionRepository, RankManagementService rankManagementService, MemberService memberService, PasswordEncoder passwordEncoder) {
        this.placeRepository = placeRepository;
        this.memberRepository = memberRepository;
        this.emissionsSettingRepository = emissionsSettingRepository;
        this.annualEmissionsRepository = annualEmissionsRepository;
        this.rank_managementRepository = rank_managementRepository;
        this.emissionsStandardSettingRepository = emissionsStandardSettingRepository;
        this.sensorListRepository = sensorListRepository;
        this.mongoQuary = mongoQuary;
        this.logRepository = logRepository;
        this.emissionsTransitionRepository = emissionsTransitionRepository;
        this.rankManagementService = rankManagementService;
        this.memberService = memberService;
        this.passwordEncoder = passwordEncoder;
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
    @RequestMapping("/")
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
                EmissionsTransition emissionsTransition = emissionsTransitionRepository.findByTableNameAndYearEquals(emissionsSettings.get(i).getSensor(),year-1);
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
    }       // dashboard
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
        }else{
            List logList = logRepository.findById(id);
            model.addAttribute("logList", logList);
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
    /**
     * 회원가입페이지로 이동
     * @return memberJoin.jsp
     */
    @RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
    public String memberJoinGet() {
        return "memberJoin";
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
    public @ResponseBody String memberSignUp(String id, String iNumber){
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
    public @ResponseBody String gaveRank(String id, String value){
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
    public @ResponseBody String resetPassword(String id){
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
    public @ResponseBody String kickMember(String id){
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
    /**
     * 로그정보를 날짜추가후 DB에 저장
     * @param log Log정보
     */
    @RequestMapping(value = "/inputLog", method = RequestMethod.POST)
    @ResponseBody
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
    @ResponseBody
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
    @ResponseBody
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
        return rank_managementRepository.findByName(str);
    }           // getRank
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