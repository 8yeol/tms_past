package com.example.tms.controller.scheduler;

import com.example.tms.entity.Place;
import com.example.tms.repository.PlaceRepository;
import com.example.tms.repository.SensorCustomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
public class Schedule {

    final
    PlaceRepository placeRepository;

    final
    SensorCustomRepository sensorCustomRepository;

    public Schedule(PlaceRepository placeRepository, SensorCustomRepository sensorCustomRepository) {
        this.placeRepository = placeRepository;
        this.sensorCustomRepository = sensorCustomRepository;
    }

//    @Scheduled(cron = "0 0/5 * * * *")
    @Scheduled(cron = "*/3 * * * * *") //3초 마다
    public void scheduling(){

        /* 측정소 전체 정보 */
        List<Place> places = placeRepository.findAll();
//        System.out.println(places);

        /* 측정소의 센서명 */
        List<String> sensor_name = new ArrayList<>();
        for(int i=0; i<places.size(); i++){
            String place_name = places.get(i).getName();
            sensor_name.add(String.valueOf(placeRepository.findByName(place_name).getSensor()));
        }
        System.out.println(sensor_name);

        List<Object> sensor = new ArrayList<>();
        for (int i=0; i<sensor_name.size(); i++){
        }
        /* 센서 리스트 마지막*/

        /*  기준 체크 */
        /* 엔티티 저장 */
        System.out.println("스케쥴링 테스트 : " + new Date());
    }


}
//        1. place.name(place 테이블의 name 컬럼)
//        model.addAttribute("place", placeRepository.findAll());

//        2. place.sensor (입력 받은 place 의 sensor 컬럼)
//        model.addAttribute("sensors", sensors);

//        List<Object> sensor = new ArrayList<>();
//        List<Object> sensor_info = new ArrayList<>();
//        3. sensor (sensor 테이블)
//        for(int i=0; i<sensors.size(); i++){
//            sensor.add(sensorCustomRepository.getSensorRecent(sensors.get(i)) );
//            sensor_info.add(sensor_infoRepository.findByName(sensors.get(i)) );
//        model.addAttribute("sensor", sensor);
//        model.addAttribute("sensor_info", sensor_info);
//        return "sensor";

//    }*/
