package com.example.tms.controller;

import com.example.tms.entity.Place;
import com.example.tms.repository.PlaceRepository;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

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
    public void scarchChart(HttpServletResponse response,String date_start, String date_end, String item, boolean off) throws Exception {
        System.out.println(date_start);
        System.out.println(date_end);
        System.out.println(item);
        System.out.println(off);

        // string to date
        SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date from = transFormat.parse(date_start);
        Date to = transFormat.parse(date_end);

        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").dateAsFormattedString("%Y-%m-%d %H:%M:%S").as("up_time")
                .and("value").as("value")
                .and("status").as("status");

        /*
        MatchOperation where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("up_time")
                                .gte(to)
                                .lte(from)
                )
        );
        */

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        //그룹함수
        /*
        GroupOperation groupBy = Aggregation.group("conv_date","type1","type2").count().as("count")
                .sum("number").as("num_sum");
        */

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                sort
        );

        AggregationResults<HashMap> results = mongoTemplate.aggregate(agg, item, HashMap.class);

        List<HashMap> result = results.getMappedResults();

        System.out.println(result);

        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print("");
        out.flush();
        out.close();
    }


    @RequestMapping("/stationManagement")
    public String stationManagement(){

        return "stationManagement";
    }
}
