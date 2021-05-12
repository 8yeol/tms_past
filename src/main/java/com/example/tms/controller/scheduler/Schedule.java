package com.example.tms.controller.scheduler;

import com.example.tms.entity.*;
import com.example.tms.repository.*;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsCustomRepository;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Component
public class Schedule {

    final PlaceRepository placeRepository;
    final NotificationListRepository notificationListRepository;
    final SensorCustomRepository sensorCustomRepository;
    final NotificationSettingsRepository notification_settingsRepository;
    final ReferenceValueSettingRepository reference_value_settingRepository;
    final NotificationDayStatisticsRepository notificationDayStatisticsRepository;
    final NotificationMonthStatisticsRepository notificationMonthStatisticsRepository;
    final NotificationListCustomRepository notificationListCustomRepository;

    final MonthlyEmissionsRepository monthlyEmissionsRepository;
    final MonthlyEmissionsCustomRepository monthlyEmissionsCustomRepository;
    final SensorListRepository sensorListRepository;

    public Schedule(PlaceRepository placeRepository, NotificationListRepository notificationListRepository,
                    SensorCustomRepository sensorCustomRepository, NotificationSettingsRepository notification_settingsRepository,
                    ReferenceValueSettingRepository reference_value_settingRepository, NotificationDayStatisticsRepository notificationDayStatisticsRepository,
                    NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, NotificationListCustomRepository notificationListCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, MonthlyEmissionsCustomRepository monthlyEmissionsCustomRepository, SensorListRepository sensorListRepository) {
        this.placeRepository = placeRepository;
        this.notificationListRepository = notificationListRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.monthlyEmissionsRepository = monthlyEmissionsRepository;
        this.monthlyEmissionsCustomRepository = monthlyEmissionsCustomRepository;
        this.sensorListRepository = sensorListRepository;
    }

    //@Scheduled(cron = "0 0/5 * * * *")
    //@Scheduled(cron = "*/1 * * * * *")
    public void scheduling(){
        List<NotificationSettings> notification = notification_settingsRepository.findByStatusIsTrue();

        // 설정 된 알림 시간에만 알림되도록 수정 (from ~ to)
        for(int i=0; i<notification.size(); i++){
            String sensorName = notification.get(i).getName();
            ReferenceValueSetting reference = reference_value_settingRepository.findByName(sensorName);

            Sensor sensor = sensorCustomRepository.getSensorRecent(sensorName);
            Float value = sensor.getValue();
            Date update = sensor.getUp_time();

            Float legal = reference.getLegalStandard(); // 법적기준
            Float company = reference.getCompanyStandard(); //사내기준
            Float standard = reference.getManagementStandard(); //관리기준

            String naming = reference.getNaming();
            String place = placeRepository.findBySensorIsIn(sensorName).getName();

            // collection 에 마지막 업데이트 된 날짜와 비교해서 5분 이상이면 알림X (이하인 경우만 아래 로직 실행)
            long minute = (new Date().getTime() - update.getTime())/60000;
            String notify; //초과알림
            int grade;
            if(minute <= 5) {
                if (value > legal) {
                    notify = "법적기준 초과";
                    grade = 1;
                    notification(place, naming, grade, notify, value);
                } else if (value > company) {
                    notify = "사내기준 초과";
                    grade = 2;
                    notification(place, naming, grade, notify, value);
                } else if (value >= standard) {
                    notify = "관리기준 초과";
                    grade = 3;
                    notification(place, naming, grade, notify, value);
                }
            }
        }
    }

    public void notification(String place, String sensor, int grade, String notify, float value){
        NotificationList notificationList = new NotificationList();
        notificationList.setPlace(place);
        notificationList.setSensor(sensor);
        notificationList.setValue(value);
        notificationList.setGrade(grade);
        notificationList.setNotify(notify);
        notificationList.setUp_time(new Date());
        notificationListRepository.save(notificationList);
    }


    @Scheduled(cron = "0 0 0 1 * *") // 매 월 1일 00시 실행
    public void monthlyEmissionsScheduling(){
        LocalDate today = LocalDate.now();
        LocalDate lastMonth = today.minus(1, ChronoUnit.MONTHS);
        LocalDate from = lastMonth.withDayOfMonth(1);
        LocalDate to = lastMonth.withDayOfMonth(lastMonth.lengthOfMonth());

        for(SensorList sensorList : sensorListRepository.findAll()){
            MonthlyEmissions monthlyEmissions = monthlyEmissionsRepository.findBySensorAndYear(sensorList.getTableName(), from.getYear());
            Double value = monthlyEmissionsCustomRepository.addStatisticsData(sensorList.getTableName(), from.toString(), to.toString());

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
            monthlyEmissionsRepository.save(monthlyEmissions);
        }
    }


    /* 알림 현황 전날(day) 이번달(month) 데이터 입력 ※매달 1일은 지난달로 계산 */
    @Scheduled(cron = "0 1 0 * * *") //매일 00시 01분에 처리
    public void saveNotiStatistics(){
        LocalDate nowDate = LocalDate.now();

        /* 일 데이터 입력 : 어제 */
        try {
            LocalDate getYesterday = nowDate.minusDays(1); //전날 데이터 입력
            notificationDayStatisticsRepository.deleteByDay(String.valueOf(getYesterday)); //데이터가 존재할 경우 삭제
            int arr[] = new int[3];
            for(int grade=1; grade<=3; grade++) {
                List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(getYesterday), String.valueOf(getYesterday));
                arr[grade-1] = (int) list.get(0).get("count");
            }
            NotificationDayStatistics ns = new NotificationDayStatistics(String.valueOf(getYesterday), arr[0], arr[1], arr[2]);
            notificationDayStatisticsRepository.save(ns);
        } catch (Exception e) {

        }

        /* 월 데이터 입력 : 이번 달 */
        try {
            int getDay = nowDate.getDayOfMonth();
            if(getDay == 1){ //매달 1일인 경우 지난달 계산
                nowDate = nowDate.minusDays(1);
            }
            int lastday = nowDate.lengthOfMonth();
            int getYear = nowDate.getYear();
            int getMonth = nowDate.getMonthValue();
            String date = String.valueOf(nowDate).substring(0,7); //'yyyy-mm'
            notificationMonthStatisticsRepository.deleteByMonth(date); //데이터가 존재할 경우 삭제
            LocalDate fromDate = LocalDate.of(getYear, getMonth, 1); //
            LocalDate toDate = LocalDate.of(getYear, getMonth, lastday);
            int arr[] = new int[3];
            for(int grade=1; grade<=3; grade++) {
                List<HashMap> list = notificationListCustomRepository.getCount(grade, String.valueOf(fromDate), String.valueOf(toDate));
                arr[grade-1] = (int) list.get(0).get("count");
            }
            NotificationMonthStatistics ns = new NotificationMonthStatistics(date, arr[0], arr[1], arr[2]);
            notificationMonthStatisticsRepository.save(ns);
        } catch (Exception e) {

        }

    }


}