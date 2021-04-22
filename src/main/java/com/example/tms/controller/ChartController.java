package com.example.tms.controller;

import com.example.tms.repository.PlaceQueryDslRepository;
import com.example.tms.repository.SensorCustomRepository;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Log4j2
public class ChartController {

    final
    PlaceQueryDslRepository placeRepository;

    final
    SensorCustomRepository sensorRepository;

    public ChartController(PlaceQueryDslRepository placeRepository, SensorCustomRepository sensorRepository) {
        this.placeRepository = placeRepository;
        this.sensorRepository = sensorRepository;
    }

    // =====================================================================================================================
// 측정소 별 센서 상세 페이지 (ppt-4페이지)
// param # key : String place (place.name)
// =====================================================================================================================
    @RequestMapping(value = "/sensor", method = RequestMethod.GET)
    public String sensor(@RequestParam("place") String place, Model model){
//        1. place.name(place 테이블의 name 컬럼)
        model.addAttribute("place", placeRepository.getPlaceInfo());

//        2. place.sensor (입력 받은 place 의 sensor 컬럼)
        List<String> sensors = placeRepository.getSensorList(place);
        model.addAttribute("sensors", sensors);

//        3. sensor (sensor 테이블)
        for(int i=0; i<sensors.size(); i++){
            model.addAttribute("sensor"+i, sensorRepository.getSenor(sensors.get(i), "","", "1"));
        }
        return "sensor";
    }
}
