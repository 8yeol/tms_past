package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.repository.MemberRepository;
import com.example.tms.repository.PlaceRepository;
import com.example.tms.repository.Sensor_AlarmRepository;
import com.example.tms.repository.Sensor_InfoRepository;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MainController {

    final PlaceRepository placeRepository;

    final Sensor_InfoRepository sensor_infoRepository;

    final MongoTemplate mongoTemplate;

    final MemberRepository memberRepository;

    final Sensor_AlarmRepository sensor_alarmRepository;

    public MainController(PlaceRepository placeRepository, Sensor_InfoRepository sensor_infoRepository, MongoTemplate mongoTemplate, Sensor_AlarmRepository sensor_alarmRepository, MemberRepository memberRepository) {
        this.placeRepository = placeRepository;
        this.sensor_infoRepository = sensor_infoRepository;
        this.mongoTemplate = mongoTemplate;
        this.memberRepository = memberRepository;
        this.sensor_alarmRepository = sensor_alarmRepository;
    }

    @RequestMapping("/")
    public String index(){
        return "dashboard";
    }

    @RequestMapping("/monitoring")
    public void monitoring(Model model){
        model.addAttribute("place", placeRepository.findAll());
    }

    @RequestMapping(value = "/sensor", method = RequestMethod.GET)
    public void sensorInfo(Model model){
        model.addAttribute("place", placeRepository.findAll());
    }

    @RequestMapping("/alarm")
    public String alarm(){
        return "alarm";
    }
    @RequestMapping("/sensorManagement")
    public String sensorManagement(){
        return "sensorManagement";
    }
    @RequestMapping("/alarmSetting")
    public String alarmSetting(){
        return "alarmSetting";
    }

    @RequestMapping("/setting")
    public String setting(Model model){
        List<Member> members = memberRepository.findAll();
        model.addAttribute("members" , members);
        return "setting";
    }

    @RequestMapping("/dataStatistics")
    public String statistics(Model model){

        List<Place> places = placeRepository.findAll();

        List<String> placelist = new ArrayList<>();
        for(Place place : places){
            placelist.add(place.getName());
        }

        model.addAttribute("place", placelist);

        return "dataStatistics";
    }

    @RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
    public String memberJoinGet(){
        return "memberJoin";
    }

    @RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
    @ResponseBody
    public void memberJoinPost(@RequestBody Member member,HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();

/*        memberRepository.deleteAll();
        for(int i=0;i < 51; i++){
            Member member1 = new Member();
            member1.setId("testId"+i);
            member1.setTel("010-"+"12"+i+"-123"+i);
            member1.setName("testName"+i);
            member1.setEmail("testEmail"+i+"@dot.com");
            member1.setState("0");
            memberRepository.save(member1);
        }*/

        if (!memberRepository.existsById(member.getId())) {
            member.setState("0");
            memberRepository.save(member);
            out.print("true");
        }else{
            out.print("false");
        }
    }           // memberJoinPost

    @RequestMapping(value = "/signUpOk", method = RequestMethod.POST)
    @ResponseBody
    public void memberSignUpOk(@RequestBody Member member){
        Member newMember = memberRepository.findById(member.getId());
        newMember.setState("1");  //0: 대기, 1: 승인 , 2: 거절
        Date time = new Date();
        newMember.setJoined(time);
        memberRepository.save(newMember);
    }           // memberSignUpOk

    @RequestMapping(value = "/signUpNo", method = RequestMethod.POST)
    @ResponseBody
    public void memberSignUpNo(@RequestBody Member member){
        Member newMember = memberRepository.findById(member.getId());
        newMember.setState("2");  //0: 대기, 1: 승인 , 2: 거절
        memberRepository.save(newMember);
    }           // memberSignUpNo

    @RequestMapping("/dataInquiry")
    public String dataInquiry(Model model){

        List<Place> places = placeRepository.findAll();

        List<String> placelist = new ArrayList<>();
        for(Place place : places){
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

        if( off == true ) {
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

        if( off == true ) {
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
    public List addStatisticsData(int year, String item){
        int[] months = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
        List data = new ArrayList();

        for(int i = 0 ; i <months.length; i++){
            Map<String, String> map = getLastDay(year,months[i]);
            String from = map.get("from");
            String to = map.get("to");
            ProjectionOperation dateProjection = Aggregation.project()
                    .and("up_time").as("up_time")
                    .and("value").as("value")
                    .and("status").as("status");

            MatchOperation where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("up_time")
                                    .gte(LocalDateTime.parse( from + "T00:00:00"))
                                    .lte(LocalDateTime.parse( to + "T23:59:59"))
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
            if( result.size() != 0){
                data.add(result.get(0).get("sum_value"));
            } else{
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
        from.set(year,  month-1, 1); //월은 -1해줘야 해당월로 인식

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
    public String alarmManagement(Model model){
        List<Place> places = placeRepository.findAll();
        List<String> placelist = new ArrayList<>();

        for(Place place : places){
            placelist.add(place.getName());
        }

        model.addAttribute("place", placelist);

        return "alarmManagement";
    }
    //알림 설정값 저장
    @RequestMapping("/saveAlarm")
    public void saveAlarm(String item, String stime, String etime, String status) {

        Date up_time = new Date();

        boolean status1 = Boolean.parseBoolean(status);
        Sensor_Alarm info = sensor_alarmRepository.findByName(item);

        Sensor_Alarm entity = new Sensor_Alarm(item, stime, etime, status1, up_time);
        try{
            entity.set_id(info.get_id());
            sensor_alarmRepository.save(entity);

        } catch (NullPointerException e){
            sensor_alarmRepository.save(entity);
        }

    }

// =====================================================================================================================
// 측정소 관리페이지 (ppt-9페이지)
//
// =====================================================================================================================
    @RequestMapping("/stationManagement")
    public String stationManagement(Model model){
        List<Place> places = placeRepository.findAll();
        model.addAttribute("place",places);

        return "stationManagement";
    }
}
