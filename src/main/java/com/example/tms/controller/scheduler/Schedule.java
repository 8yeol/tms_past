package com.example.tms.controller.scheduler;

import com.example.tms.entity.*;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsCustomRepository;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsRepository;
import com.example.tms.repository.NotificationStatistics.NotificationDayStatisticsRepository;
import com.example.tms.repository.NotificationList.NotificationListCustomRepository;
import com.example.tms.repository.NotificationStatistics.NotificationMonthStatisticsRepository;
import com.example.tms.repository.SensorListRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Component
public class Schedule {

    final NotificationDayStatisticsRepository notificationDayStatisticsRepository;
    final NotificationMonthStatisticsRepository notificationMonthStatisticsRepository;
    final NotificationListCustomRepository notificationListCustomRepository;
    final MonthlyEmissionsRepository monthlyEmissionsRepository;
    final MonthlyEmissionsCustomRepository monthlyEmissionsCustomRepository;
    final SensorListRepository sensorListRepository;

    public Schedule(NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, NotificationListCustomRepository notificationListCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, MonthlyEmissionsCustomRepository monthlyEmissionsCustomRepository, SensorListRepository sensorListRepository) {
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.monthlyEmissionsRepository = monthlyEmissionsRepository;
        this.monthlyEmissionsCustomRepository = monthlyEmissionsCustomRepository;
        this.sensorListRepository = sensorListRepository;
    }

    /**
     * 매 월 1일 00시 실행 (매월 1일 전월 데이터 통계)
     * [분석 및 통계 > 통계자료 조회]
     * 해당 시점에 등록된 센서목록 전체 읽어와서 해당 컬렉션의 통계자료 DB 저장
     */
    @Scheduled(cron = "0 0 0 1 * *")
    public void monthlyEmissionsScheduling(){
        LocalDate today = LocalDate.now();
        LocalDate lastMonth = today.minus(1, ChronoUnit.MONTHS);
        LocalDate from = lastMonth.withDayOfMonth(1);
        LocalDate to = lastMonth.withDayOfMonth(lastMonth.lengthOfMonth());

        for(SensorList sensorList : sensorListRepository.findAll()){
            MonthlyEmissions monthlyEmissions = monthlyEmissionsRepository.findBySensorAndYear(sensorList.getTableName(), from.getYear());
            Double value = monthlyEmissionsCustomRepository.addStatisticsData(sensorList.getTableName(), from.toString(), to.toString());

            if(monthlyEmissions==null){
                monthlyEmissions = new MonthlyEmissions();
                monthlyEmissions.setYear(from.getYear());
                monthlyEmissions.setSensor(sensorList.getTableName());
            }

            if(from.getMonthValue()==1){
                monthlyEmissions.setJan(value);
            } else if(from.getMonthValue()==2){
                monthlyEmissions.setFeb(value);
            }else if(from.getMonthValue()==3){
                monthlyEmissions.setMar(value);
            }else if(from.getMonthValue()==4){
                monthlyEmissions.setApr(value);
            }else if(from.getMonthValue()==5){
                monthlyEmissions.setMay(value);
            }else if(from.getMonthValue()==6){
                monthlyEmissions.setJun(value);
            }else if(from.getMonthValue()==7){
                monthlyEmissions.setJul(value);
            }else if(from.getMonthValue()==8){
                monthlyEmissions.setAug(value);
            }else if(from.getMonthValue()==9){
                monthlyEmissions.setSep(value);
            }else if(from.getMonthValue()==10){
                monthlyEmissions.setOct(value);
            }else if(from.getMonthValue()==11){
                monthlyEmissions.setNov(value);
            }else if(from.getMonthValue()==12){
                monthlyEmissions.setDec(value);
            }

            monthlyEmissions.setUpdateTime(new Date());

            monthlyEmissionsRepository.save(monthlyEmissions);
        }
    }

    /**
     * [알림 - 센서 알림현황]
     * 기준 초과 알림 목록을 읽어와 기준별 카운트하여 일별/월별로 해당 컬렉션에 저장
     * (알림 현황 전날(day) 이번달(month) 데이터 입력 ※매달 1일은 지난달로 계산)
     */
    @Scheduled(cron = "0 1 0 * * *") //매일 00시 01분에 처리
    public void saveNotificationStatistics(){
        LocalDate nowDate = LocalDate.now();
        // 어제 날짜 불러오기
        LocalDate yesterday = nowDate.minusDays(1);
        // 어제 날짜로 저장되어있는 데이터 불러오기
        NotificationDayStatistics yesterdayData = notificationDayStatisticsRepository.findByDay(String.valueOf(yesterday));
        // 어제 날짜 데이터가 없는 경우 new 객체 생성 후 데이터 set
        if(yesterdayData == null){
            yesterdayData = new NotificationDayStatistics();
        }
        yesterdayData.setDay(String.valueOf(yesterday));

        int[] dayValue = getReferenceValueCount(String.valueOf(yesterday), String.valueOf(yesterday));
        yesterdayData.setLegalCount(dayValue[0]);
        yesterdayData.setCompanyCount(dayValue[1]);
        yesterdayData.setManagementCount(dayValue[2]);
        notificationDayStatisticsRepository.save(yesterdayData);

        // 오늘 날짜 체크 (1일인 경우 전일데이터로 계산)
        int getDay = nowDate.getDayOfMonth();
        if (getDay == 1)
            nowDate = nowDate.minusDays(1);

        // nowDate 해당월의 시작일
        LocalDate from = nowDate.withDayOfMonth(1);
        // nowDate 해당월의 종료일
        LocalDate to = nowDate.withDayOfMonth(nowDate.lengthOfMonth());

        // nowDate 날짜 포맷변경 DB 저장용(YYYY-MM)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("YYYY-MM");
        String year_month = formatter.format(nowDate);

        NotificationMonthStatistics monthData = notificationMonthStatisticsRepository.findByMonth(year_month);
        if(monthData == null){
            monthData = new NotificationMonthStatistics();
        }

        monthData.setMonth(year_month);

        int[] monthValue = getReferenceValueCount(String.valueOf(from), String.valueOf(to));
        monthData.setLegalCount(monthValue[0]);
        monthData.setCompanyCount(monthValue[1]);
        monthData.setManagementCount(monthValue[2]);
        notificationMonthStatisticsRepository.save(monthData);
    }

    public int[] getReferenceValueCount(String from, String to){
        int[] arr = new int[3];
        for(int grade=1; grade<=3; grade++) {
            List<HashMap> list = notificationListCustomRepository.getCount(grade, from, to);
            if (list.size() != 0) {
                arr[grade - 1] = (int) list.get(0).get("count");
            } else {
                arr[grade - 1] = 0;
            }
        }
        return arr;
    }
}