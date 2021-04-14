package com.example.tms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChartController {

    @RequestMapping("/sensor")
    public String sensor(){
        return "sensor";
    }
}
