package com.example.tms.controller;

import com.example.tms.entity.ChartData;
import com.example.tms.entity.Place;
import com.example.tms.entity.Sensor_Info;
import com.example.tms.repository.PlaceRepository;
import com.example.tms.repository.Sensor_InfoRepository;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MainController {



    final PlaceRepository placeRepository;

    final Sensor_InfoRepository sensor_infoRepository;

    final MongoTemplate mongoTemplate;

    public MainController(PlaceRepository placeRepository, Sensor_InfoRepository sensor_infoRepository, MongoTemplate mongoTemplate) {
        this.placeRepository = placeRepository;
        this.sensor_infoRepository = sensor_infoRepository;
        this.mongoTemplate = mongoTemplate;
    }

    @RequestMapping("/")
    public String index(){
        return "dashboard";
    }

    @RequestMapping("/monitoring")
    public String monitoring(){
        return "monitoring";
    }

    @RequestMapping("/statistics")
    public String statistics(){
        return "statistics";
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
    public String setting(){
        return "setting";
    }



    /*@RequestMapping("stationManagement")*/

    @RequestMapping("/dataInquiry")
    public String dataInquiry(Model model){

        List<Place> places = (List<Place>) placeRepository.findAll();

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

// =====================================================================================================================
// 알림 설정페이지 (ppt-8페이지)
// param # key : String place (place.name)
// =====================================================================================================================
    @RequestMapping(value = "/alarmManagement", method = RequestMethod.GET)
    public String alarmManagement(@RequestParam("place") String name, Model model, HttpServletResponse response) throws IOException {
        List<Place> places = placeRepository.findAll();
        Place place = placeRepository.findByName(name);
        System.out.println(place);
        List<String> sensors = place.getSensor();
        List sensorInfo = new ArrayList();

        for(int i=0;i<sensors.size();i++){
            sensorInfo.add(sensor_infoRepository.findByName(sensors.get(i)));
            System.out.println("sensor"+i+", "+sensor_infoRepository.findByName(sensors.get(i)));
        }
        model.addAttribute("sensorInfo",sensorInfo);
        model.addAttribute("station", places);

        return "alarmManagement";
    }
//    @RequestMapping(value = "/getSensorInfo", method = RequestMethod.POST)
//    public String getSensorInfo(String name, Model model){
//        Place place = placeRepository.findByName(name);
//        System.out.println("111111111111");
//        System.out.println(place);
//        List<String> sensorList = place.getSensor();
//        for(int i=1;i<sensorList.size();i++){
//            model.addAttribute("sensorInfo"+i, sensor_infoRepository.findByName(sensorList.get(i)));
//        }
//        return "alarmManagement";
//    }

// =====================================================================================================================
// 측정소 관리페이지 (ppt-9페이지)
//
// =====================================================================================================================
    @RequestMapping("/stationManagement")
    public String stationManagement(){

        return "stationManagement";
    }
}
