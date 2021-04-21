package com.example.tms.controller;

import com.example.tms.entity.Place;
import com.example.tms.repository.PlaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@Controller
public class MainController {

    @Autowired
    PlaceRepository placeRepository;

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

    @RequestMapping(value = "/getPalceSensor", method = RequestMethod.POST)
    public void getPalceSensor(HttpServletResponse response, String name) throws Exception {
        Place place = placeRepository.findByName(name);
        System.out.println(placeRepository.findByName(name));

        List sensor = place.getSensor();

        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(sensor);
        out.flush();
        out.close();
    }


    @RequestMapping("/stationManagement")
    public String stationManagement(){

        return "stationManagement";
    }
}
