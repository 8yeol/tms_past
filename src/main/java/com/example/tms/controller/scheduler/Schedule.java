package com.example.tms.controller.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class Schedule {
    @Scheduled(cron = "0 0/5 * * * *")
    public void scheduling(){
        System.out.println("스케쥴링 테스트 : " + new Date());
    }
}
