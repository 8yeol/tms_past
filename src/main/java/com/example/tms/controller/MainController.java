package com.example.tms.controller;

import com.example.tms.entity.*;
import com.example.tms.repository.PlaceRepository;
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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MainController {



    final PlaceRepository placeRepository;

    final Sensor_InfoRepository sensor_infoRepository;

    final MongoTemplate mongoTemplate;

    final MemberRepository memberRepository;

    public MainController(PlaceRepository placeRepository, Sensor_InfoRepository sensor_infoRepository, MongoTemplate mongoTemplate, MemberRepository memberRepository) {
        this.placeRepository = placeRepository;
        this.sensor_infoRepository = sensor_infoRepository;
        this.mongoTemplate = mongoTemplate;
        this.memberRepository = memberRepository;
    }

    @RequestMapping("/")
    public String index(){
        return "dashboard";
    }

    @RequestMapping("/monitoring")
    public String monitoring(){
        return "monitoring";
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
        List<Member> members = memberRepository.findByState("0");
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
        if(member == null)
        if (!memberRepository.existsById(member.getId())) {
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
    public List<Map> addStatisticsData(String place, String item){
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("up_time")
                .and("value").as("value")
                .and("status").as("status");

        MatchOperation where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("up_time")
                                    .gte(LocalDateTime.parse("2021-04-01" + "T00:00:00"))
                                    .lte(LocalDateTime.parse("2021-04-30" + "T23:59:59"))
                    )
            );

        GroupOperation groupBy = Aggregation.group().sum("value").as("april");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                groupBy
        );

        AggregationResults<Map> results = mongoTemplate.aggregate(agg, item, Map.class);

        List<Map> result = results.getMappedResults();

        return result;
    }

// =====================================================================================================================
// 알림 설정페이지 (ppt-8페이지)
// param # key : String place (place.name)
// =====================================================================================================================

    @RequestMapping(value = "/alarmManagement", method = RequestMethod.GET)
    public String alarmManagement(Model model){
        List<Place> places = placeRepository.findAll();

        List<String> placelist = new ArrayList<>();

        for(Place place : places){
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
    public String stationManagement(){

        return "stationManagement";
    }
}
