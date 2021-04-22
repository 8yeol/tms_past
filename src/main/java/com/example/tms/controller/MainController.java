package com.example.tms.controller;

import com.example.tms.entity.ChartData;
import com.example.tms.entity.Place;
import com.example.tms.repository.PlaceRepository;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MainController {

    final PlaceRepository placeRepository;

    final MongoTemplate mongoTemplate;

    public MainController(PlaceRepository placeRepository, MongoTemplate mongoTemplate) {
        this.placeRepository = placeRepository;
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

    /*@RequestMapping("stationManagement")*/

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

    @RequestMapping(value = "/getPalceSensor", method = RequestMethod.POST)
    public void getPalceSensor(HttpServletResponse response, String name) throws Exception {
        Place place = placeRepository.findByName(name);
        List sensorList = place.getSensor();

        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(sensorList);
        out.flush();
        out.close();
    }

    @RequestMapping(value = "/scarchChart", method = RequestMethod.POST)
    @ResponseBody
    public List<ChartData> scarchChart(String date_start, String date_end, String item, boolean off) {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("up_time")
                .and("_id").as("id")
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

        AggregationResults<ChartData> results = mongoTemplate.aggregate(agg, item, ChartData.class);

        List<ChartData> result = results.getMappedResults();

        return result;
    }

    @RequestMapping("/stationManagement")
    public String stationManagement(){

        return "stationManagement";
    }
}
