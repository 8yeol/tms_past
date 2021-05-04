package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.repository.*;
import com.example.tms.repository.Reference_Value_SettingRepository;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MainController {

    final PlaceRepository placeRepository;

    final Reference_Value_SettingRepository reference_value_settingRepository;

    final MongoTemplate mongoTemplate;

    final MemberRepository memberRepository;

    final Notification_SettingsRepository notification_settingsRepository;

    final EmissionsSettingRepository emissionsSettingRepository;

    final YearlyEmissionsSettingRepository yearlyEmissionsSettingRepository;

    final Rank_ManagementRepository rank_managementRepository;

    final YearlyEmissionsRepository yearlyEmissionsRepository;

    public MainController(PlaceRepository placeRepository, Reference_Value_SettingRepository reference_value_settingRepository, MongoTemplate mongoTemplate,
                          MemberRepository memberRepository, Notification_SettingsRepository notification_settingsRepository, EmissionsSettingRepository emissionsSettingRepository,
                          YearlyEmissionsSettingRepository yearlyEmissionsSettingRepository, Rank_ManagementRepository rank_managementRepository, YearlyEmissionsRepository yearlyEmissionsRepository) {
        this.placeRepository = placeRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.mongoTemplate = mongoTemplate;
        this.memberRepository = memberRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.emissionsSettingRepository = emissionsSettingRepository;
        this.yearlyEmissionsSettingRepository = yearlyEmissionsSettingRepository;
        this.rank_managementRepository = rank_managementRepository;
        this.yearlyEmissionsRepository = yearlyEmissionsRepository;
    }


    @RequestMapping("/")
    public String index(Model model) {
        //선택된 센서 (findByStatusIsTrue) , 연간 배출량 (findAll) 가져오기
        List<YearlyEmissionsSetting> setting = yearlyEmissionsSettingRepository.findByStatusIsTrue();
        List<YearlyEmissions> yEmissions = yearlyEmissionsRepository.findAll();
        List<YearlyEmissions> yearlyEmissions = new ArrayList<>();

        //연간 배출량센서가 설정되어있는지 판단
        for (int i = 0; i < setting.size(); i++) {         /*선택된 센서*/
            for(int j = 0; j<yEmissions.size(); j++) {     /*연간 배출량 센서*/
                if (setting.get(i).getPlace().equals(yEmissions.get(j).getPlace()) &&
                        setting.get(i).getSensor_naming().equals(yEmissions.get(j).getSensor_naming())) {
                    yearlyEmissions.add(yEmissions.get(j));
                }
            }
        }
        model.addAttribute("sensorlist",yearlyEmissions);

        //선택된 센서 측정소 중복제거  List -> Set
        List<String> placelist = new ArrayList<>();
        for (YearlyEmissionsSetting place : setting) {
            placelist.add(place.getPlace());
        }
        TreeSet<String> placeSet = new TreeSet<>(placelist);
        model.addAttribute("placelist", placeSet);

        return "dashboard";
    }

    @RequestMapping("/monitoring")
    public void monitoring(Model model) {
        model.addAttribute("place", placeRepository.findAll());
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
    public String sensorManagement() {
        return "sensorManagement";
    }

    @RequestMapping("/alarmSetting")
    public String alarmSetting() {
        return "alarmSetting";
    }

    @RequestMapping("/setting")
    public String setting(Model model) {
        List<Member> members = memberRepository.findAll();
        List<rank_management> rank_managements = rank_managementRepository.findAll();
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
        memberRepository.deleteAll();
        for (int i = 0; i < 51; i++) {
            Member member1 = new Member();
            member1.setId("testId" + i);
            member1.setPassword((UUID.randomUUID().toString().replaceAll("-", "")).substring(0, 10));
            member1.setTel("010-" + "12" + i + "-123" + i);
            member1.setName("testName" + i);
            member1.setEmail("testEmail" + i + "@dot.com");
            member1.setState("1");
            memberRepository.save(member1);
        }
/*        if (!memberRepository.existsById(member.getId())) {
            member.setState("1"); // 0: 거절 - 1: 가입대기 - 2: 일반 - 3: 관리자 - 4: 최고관리자
            memberRepository.save(member);
            out.print("true");
        }else{
            out.print("false");
        }*/
    }           // memberJoinPost

    @RequestMapping(value = "/signUp", method = RequestMethod.POST)
    public @ResponseBody
    String memberSignUp(String id, String iNumber) {
        String msg = "";
        Member newMember = memberRepository.findById(id);
        if (iNumber.equals("0")) {
            newMember.setState("0");
            msg = "가입 거절 되었습니다.";
        } else {
            newMember.setState("2"); // 0: 거절 - 1: 가입대기 - 2: 일반 - 3: 관리자 - 4: 최고관리자
            Date time = new Date();
            newMember.setJoined(time); // 가입승인일 설정
            msg = "가입 승인 되었습니다.";
        }
        memberRepository.save(newMember);
        return msg;
    }           // memberSignUp

    @RequestMapping(value = "/gaveRank", method = RequestMethod.POST)
    public @ResponseBody
    String gaveRank(String id, String value) {
        Member newMember = memberRepository.findById(id);
        newMember.setState(value);
        memberRepository.save(newMember);
        return "등급 부여 하였습니다.";
    }           // gaveRank

    @RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
    public @ResponseBody
    String resetPassword(String id) {
        Member newMember = memberRepository.findById(id);
        String uuid = (UUID.randomUUID().toString().replaceAll("-", "")).substring(0, 10);
        newMember.setPassword(uuid);
        memberRepository.save(newMember);
        return "비밀번호가 초기화 되었습니다. \n임시비밀번호 : " + uuid;
    }           // resetPassword

    @RequestMapping(value = "/kickMember", method = RequestMethod.POST)
    public @ResponseBody
    String kickMember(String id) {
        memberRepository.deleteById(id);
        return "탈퇴처리 되었습니다.";
    }           // kickMember


    @RequestMapping(value = "/rankSettingSave", method = RequestMethod.POST)
    @ResponseBody
    public void rankSettingSave(@RequestBody rank_management rankManagement) {
        rank_management newRankManagement = rank_managementRepository.findByName(rankManagement.getName());
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

    @RequestMapping(value = "/searchChart", method = RequestMethod.POST)
    @ResponseBody
    public List<ChartData> searchChart(String date_start, String date_end, String item, boolean off) {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("x")
                .and("value").as("y")
                .and("status").as("status");

        MatchOperation where;

        if (off == true) {
            // 모든 데이터 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("x")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        } else {
            // status true ( off 아닌 데이터 ) 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("status")
                                    .is(true)
                                    .and("x")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        }

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "x");

        //그룹함수
        /*
        GroupOperation groupBy = Aggregation.group("conv_date","type1","type2").count().as("count")
                .sum("number").as("num_sum");
        */

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                sort
        );

        AggregationResults<ChartData> results = mongoTemplate.aggregate(agg, item, ChartData.class);

        List<ChartData> result = results.getMappedResults();

        return result;
    }

    @RequestMapping(value = "/searchInformatin", method = RequestMethod.POST)
    @ResponseBody
    public List<Sensor> searchInformatin(String date_start, String date_end, String item, boolean off) {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("up_time")
                .and("value").as("value")
                .and("status").as("status");

        MatchOperation where;

        if (off == true) {
            // 모든 데이터 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("up_time")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        } else {
            // status true ( off 아닌 데이터 ) 표시
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("status")
                                    .is(true)
                                    .and("up_time")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        }

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                sort
        );

        AggregationResults<Sensor> results = mongoTemplate.aggregate(agg, item, Sensor.class);

        List<Sensor> result = results.getMappedResults();

        return result;
    }

    @RequestMapping(value = "/addStatisticsData", method = RequestMethod.POST)
    @ResponseBody
    public List addStatisticsData(int year, String item) {
        int[] months = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
        List data = new ArrayList();

        for (int i = 0; i < months.length; i++) {
            Map<String, String> map = getLastDay(year, months[i]);
            String from = map.get("from");
            String to = map.get("to");
            ProjectionOperation dateProjection = Aggregation.project()
                    .and("up_time").as("up_time")
                    .and("value").as("value")
                    .and("status").as("status");

            MatchOperation where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("up_time")
                                    .gte(LocalDateTime.parse(from + "T00:00:00"))
                                    .lte(LocalDateTime.parse(to + "T23:59:59"))
                    )
            );

            GroupOperation groupBy = Aggregation.group().sum("value").as("sum_value");

            Aggregation agg = Aggregation.newAggregation(
                    dateProjection,
                    where,
                    groupBy
            );

            AggregationResults<Map> results = mongoTemplate.aggregate(agg, item, Map.class);
            List<Map> result = results.getMappedResults();
            if (result.size() != 0) {
                data.add(result.get(0).get("sum_value"));
            } else {
                data.add(null);
            }
        }

        return data;
    }

    public Map<String, String> getLastDay(int year, int month) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, String> dayList = new HashMap<>();

        Calendar from = Calendar.getInstance();
        Calendar to = Calendar.getInstance();
        from.set(year, month - 1, 1); //월은 -1해줘야 해당월로 인식

        to.set(from.get(Calendar.YEAR), from.get(Calendar.MONTH), from.getActualMaximum(Calendar.DAY_OF_MONTH));

        dayList.put("from", dateFormat.format(from.getTime()));
        dayList.put("to", dateFormat.format(to.getTime()));

        return dayList;
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
    public String stationManagement(Model model) {
        List<Place> places = placeRepository.findAll();
        model.addAttribute("place", places);

        return "stationManagement";
    }

    @RequestMapping("emissionsManagement")
    public String emissionsManagement(Model model) {

        List<EmissionsSetting> emissions = emissionsSettingRepository.findAll();
        model.addAttribute("target", emissions);

        List<YearlyEmissionsSetting> yearlyEmissions = yearlyEmissionsSettingRepository.findAll();
        model.addAttribute("target2", yearlyEmissions);

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
            YearlyEmissionsSetting target = yearlyEmissionsSettingRepository.findBySensor(sensor);
            target.setStatus(!target.isStatus());
            yearlyEmissionsSettingRepository.save(target);
        }
    }

}
