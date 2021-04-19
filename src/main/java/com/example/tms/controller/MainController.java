package com.example.tms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

    @RequestMapping("/")
    public String index(){

        return "dashboard";
    }
    @RequestMapping("stationManagement")
    public String stationManagement(){

        return "stationManagement";
    }
}
