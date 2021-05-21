package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.*;
import com.example.tms.repository.SensorListRepository;
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

    public MainController(PlaceRepository placeRepository, MemberRepository memberRepository, EmissionsSettingRepository emissionsSettingRepository, AnnualEmissionsRepository annualEmissionsRepository, RankManagementRepository rankManagementRepository, EmissionsStandardSettingRepository emissionsStandardSettingRepository, SensorListRepository sensorListRepository, MongoQuary mongoQuary, LogRepository logRepository, EmissionsTransitionRepository emissionsTransitionRepository) {
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
        // [환경설정 > 배출량 관리] - 배출 허용 기준 설정에 설정된 기준값 > 모니터링 설정된 배출량 기준값만 받아오도록 변경
        List<EmissionsStandardSetting> standard = new ArrayList<>();
        for (int i = 0; i<setting.size(); i++){
            standard.add(emissionsStandardSettingRepository.findByTableNameIsIn(setting.get(i).getSensor()));
        }
        model.addAttribute("standard",standard);

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
     */
    @RequestMapping("/monitoring")
    public void monitoring() {
    }


    /**
     * [모니터링 - 상세화면]
      @param model 전체 측정소 정보 뷰페이지로 전달
     */
    @RequestMapping(value = "/sensor", method = RequestMethod.GET)
    public void sensorInfo(Model model) {
        model.addAttribute("place", placeRepository.findAll());
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
     * [환경설정 - 측정소 관리]
     * @return stationManagement.JSP
     */
    @RequestMapping("/stationManagement")
    public String stationManagement() {

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
     * place : 등록된 모든 측정소명
     * @return alarmManagement.jsp
     */
    @RequestMapping(value = "/alarmManagement")
    public String alarmManagement(Model model) {
        List<Place> places = placeRepository.findAll();
        List<String> placeList = new ArrayList<>();

        for (Place place : places) {
            placeList.add(place.getName());
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
        model.addAttribute("member", member);
        model.addAttribute("members", members);
        model.addAttribute("rank_managements", rank_managements);
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
    @RequestMapping("/log")
    public String log(Model model, @RequestParam(value = "id") String id) {

        model.addAttribute("logList",logRepository.findById(id));
        model.addAttribute("member",memberRepository.findById(id));

        return "log";
    }

}