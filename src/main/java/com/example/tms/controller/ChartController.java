package com.example.tms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ChartController {

//    @Autowired
//    PlaceRepository placeRepository;

//    @Autowired
//    SensorRepository sensorRepository;

// =====================================================================================================================
// 측정소 별 센서 상세 페이지 (ppt-4페이지)
// param # key : String place (place.name)
// =====================================================================================================================
    @RequestMapping(value = "/sensor", method = RequestMethod.GET)
    public String sensor(@RequestParam("place") String place, Model model){

//        1. place.name(place 테이블의 name 컬럼)
//        model.addAttribute("place", placeRepository.findAll());

//        2. place.sensor (입력 받은 place 의 sensor 컬럼)
//        List<String> sensors = placeRepository.getPlaceSensor(place);
//        model.addAttribute("sensors", sensors);

//        3. sensor (sensor 테이블)
//        for(int i=0; i<sensors.size(); i++){
//            model.addAttribute("sensor"+i, sensorRepository.getSensorInfo(sensors.get(i)));
//        }
        return "sensor";
    }
}
