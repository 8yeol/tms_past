package com.example.tms.controller;


import com.example.tms.entity.Place;
import com.example.tms.entity.Sensor;
import com.example.tms.repository.PlaceCustomRepository;
import com.example.tms.repository.PlaceQueryDslRepository;
import com.example.tms.repository.SensorCustomRepository;
import com.example.tms.repository.SensorQueryDslRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;


@RestController
public class JsonController {

    final
    PlaceCustomRepository placeRepository;

    final
    SensorCustomRepository sensorRepository;

    public JsonController(PlaceCustomRepository placeRepository, SensorCustomRepository sensorRepository) {
        this.placeRepository = placeRepository;
        this.sensorRepository = sensorRepository;
    }

// *********************************************************************************************************************
// Place
// *********************************************************************************************************************

    @RequestMapping(value = "/getSensorNames")
    public List<Place> getSensorNames(@RequestParam("name") String place){
        List<Place> list = placeRepository.getSensorNames(place);
        return list;
    }

// *********************************************************************************************************************
// Sensor
// *********************************************************************************************************************

    /**
     * @param sensor (sensor sensor)
     * @param from_date,to_date ('', 'Year-Month-Day hh:mm:ss', 'Year-Month-Day', 'hh:mm:ss', 'hh:mm')
     * @param minute (60 - 1hour, 1440 - 24hour, ...)
     * @return List<Sensor> </sensor>_id, value, status, up_time
     */

    @RequestMapping(value = "/getSensor")
    public List<Sensor> getSensor(@RequestParam("sensor") String sensor, @RequestParam("from_date") String from_date, @RequestParam("to_date") String to_date, @RequestParam("minute") String minute){
        List<Sensor> list = sensorRepository.getSenor(sensor, from_date, to_date, minute);
        return list;
    }

}
