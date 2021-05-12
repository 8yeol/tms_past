package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoConfig;
import com.example.tms.repository.*;
import com.example.tms.repository.DataInquiry.DataInquiryRepository;
import com.example.tms.repository.ReferenceValueSettingRepository;
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
    final ReferenceValueSettingRepository reference_value_settingRepository;
    final MemberRepository memberRepository;
    final NotificationStatisticsCustomRepository notification_statistics_customRepository;
    final EmissionsSettingRepository emissionsSettingRepository;
    final AnnualEmissionsRepository annualEmissionsRepository;
    final RankManagementRepository rank_managementRepository;
    final ItemRepository itemRepository;
    final SensorListRepository sensorListRepository;

    final MongoConfig mongoConfig;
    final DataInquiryRepository dataInquiryRepository;

    public MainController(PlaceRepository placeRepository, ReferenceValueSettingRepository reference_value_settingRepository, MemberRepository memberRepository, NotificationStatisticsCustomRepository notification_statistics_customRepository, EmissionsSettingRepository emissionsSettingRepository, AnnualEmissionsRepository annualEmissionsRepository, RankManagementRepository rank_managementRepository, ItemRepository itemRepository, SensorListRepository sensorListRepository, MongoConfig mongoConfig, DataInquiryRepository dataInquiryRepository) {
        this.placeRepository = placeRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.memberRepository = memberRepository;
        this.notification_statistics_customRepository = notification_statistics_customRepository;
        this.emissionsSettingRepository = emissionsSettingRepository;
        this.annualEmissionsRepository = annualEmissionsRepository;
        this.rank_managementRepository = rank_managementRepository;
        this.itemRepository = itemRepository;
        this.sensorListRepository = sensorListRepository;
        this.mongoConfig = mongoConfig;
        this.dataInquiryRepository = dataInquiryRepository;
    }


    @RequestMapping("/")
    public String dashboard(Model model) {
        //선택된 센서 (findByStatusIsTrue) 가져오기
        List<AnnualEmissions> setting = annualEmissionsRepository.findByStatusIsTrue();

        model.addAttribute("sensorlist",setting);

        //선택된 센서 측정소 중복제거  List -> Set
        List<String> placelist = new ArrayList<>();
        for (AnnualEmissions place : setting) {
            placelist.add(place.getPlace());
        }
        TreeSet<String> placeSet = new TreeSet<>(placelist);
        model.addAttribute("placelist", placeSet);

        //연간 배출기준값 가져오기
        List<Item> standard = itemRepository.findAll();
        model.addAttribute("standard",standard);

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

    @RequestMapping("/sensorManagement")
    public String sensorManagement(Model model) {

       List<String> result = mongoConfig.getCollection();

       for(SensorList sensorList : sensorListRepository.findAll()){
           for(String tableName : mongoConfig.getCollection()){
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
    public String setting(Model model) {
        List<Member> members = memberRepository.findAll();
        List<RankManagement> rank_managements = rank_managementRepository.findAll();
        model.addAttribute("members", members);
        model.addAttribute("rank_managements", rank_managements);
        return "setting";
    }

    @RequestMapping("/dataStatistics")
    public String statistics(Model model) {
        List<Place> places = placeRepository.findAll();
        List<String> placelist = new ArrayList<>();
        for (Place place : places) {
            placelist.add(place.getName());
        }
        model.addAttribute("place", placelist);
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
/*        memberRepository.deleteAll();
        for(int i=0;i < 51; i++){
            Member member1 = new Member();
            member1.setId("testId"+i);
            member1.setPassword((UUID.randomUUID().toString().replaceAll("-", "")).substring(0,10));
            member1.setTel("010-"+"12"+i+"-123"+i);
            member1.setName("testName"+i);
            member1.setEmail("testEmail"+i+"@dot.com");
            member1.setState("1");
            memberRepository.save(member1);
        }*/
        if (!memberRepository.existsById(member.getId())) {
            member.setState("1"); // 0: 거절 - 1: 가입대기 - 2: 일반 - 3: 관리자 - 4: 최고관리자
            memberRepository.save(member);
            out.print("true");
        }else{
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
    @ResponseBody
    public void loginCheck(@RequestBody Member member, HttpServletResponse response) throws Exception {
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
        return "탈퇴처리 되었습니다.";
    }           // kickMember


    @RequestMapping(value = "/rankSettingSave", method = RequestMethod.POST)
    @ResponseBody
    public void rankSettingSave(@RequestBody RankManagement rankManagement) {
        RankManagement newRankManagement = rank_managementRepository.findByName(rankManagement.getName());
        newRankManagement.setDashboard(rankManagement.isDashboard());
        newRankManagement.setAlarm(rankManagement.isAlarm());
        newRankManagement.setMonitoring(rankManagement.isMonitoring());
        newRankManagement.setStatistics(rankManagement.isStatistics());
        newRankManagement.setSetting(rankManagement.isSetting());
        rank_managementRepository.save(newRankManagement);
    }           // rankSettingSave


    @RequestMapping("/dataInquiry")
    public String dataInquiry(Model model) {

        List<Place> places = placeRepository.findAll();

        List<String> placelist = new ArrayList<>();
        for (Place place : places) {
            placelist.add(place.getName());
        }

        model.addAttribute("place", placelist);

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

    @RequestMapping("emissionsManagement")
    public String emissionsManagement(Model model) {

        List<EmissionsSetting> emissions = emissionsSettingRepository.findAll();
        model.addAttribute("emissions", emissions);

        List<AnnualEmissions> yearlyEmissions = annualEmissionsRepository.findAll();
        model.addAttribute("yearlyEmissions", yearlyEmissions);

        List<Item> standard =  itemRepository.findAll();
        model.addAttribute("standard",standard);

        return "emissionsManagement";
    }

    //배출량 대상 설정
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
