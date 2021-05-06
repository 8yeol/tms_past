package com.example.tms.controller.scheduler;

import com.example.tms.entity.*;
import com.example.tms.repository.*;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
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


    public Schedule(PlaceRepository placeRepository, NotificationListRepository notificationListRepository,
                    SensorCustomRepository sensorCustomRepository, NotificationSettingsRepository notification_settingsRepository,
                    ReferenceValueSettingRepository reference_value_settingRepository, NotificationDayStatisticsRepository notificationDayStatisticsRepository,
                    NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, NotificationListCustomRepository notificationListCustomRepository) {
        this.placeRepository = placeRepository;
        this.notificationListRepository = notificationListRepository;
        this.sensorCustomRepository = sensorCustomRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
    }

    //@Scheduled(cron = "0 0/5 * * * *")
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


    /* 알림 현황 입력 */
    public void saveNotiStatistics(boolean day, boolean month){
        LocalDate nowDate = LocalDate.now(); //현재시간
        int getYear = nowDate.getYear();
        int getMonth = nowDate.getMonthValue();
        int getDay = nowDate.getDayOfMonth();
        LocalDate getYesterday = nowDate.minusDays(1);
        LocalDate getLastMonth = nowDate.minusMonths(1);

        /* 일 데이터 입력 : 어제 */
        if(day){
            notificationDayStatisticsRepository.deleteByDay(String.valueOf(getYesterday)); //데이터가 존재할 경우 삭제
            try {
                int arr[] = new int[3];
                for(int grade=1; grade<=3; grade++) {
                    List<HashMap> list = notificationListCustomRepository.getCount(grade, LocalDateTime.parse(getYesterday + "T00:00:00"), LocalDateTime.parse(getYesterday + "T23:59:59"));
                    arr[grade-1] = (int) list.get(0).get("count");
                }
                NotificationDayStatistics ns = new NotificationDayStatistics(String.valueOf(getYesterday), arr[0], arr[1], arr[2]);
                notificationDayStatisticsRepository.save(ns);
            } catch (Exception e) {
//                log.info(e.getMessage());
            }
        } //if

        /* 월 데이터 입력 : 지난 달 */
        if(month) {
            String date = String.valueOf(getLastMonth).substring(0,7);
            notificationMonthStatisticsRepository.deleteByMonth(date); //데이터가 존재할 경우 삭제
            int lastMonthOfDay = getLastMonth.lengthOfMonth();
            LocalDate from_date = LocalDate.of(getYear, getLastMonth.getMonth(), 1);
            LocalDate to_date = LocalDate.of(getYear, getLastMonth.getMonth(), lastMonthOfDay);
            try {
                int arr[] = new int[3];
                for(int grade=1; grade<=3; grade++) {
                    List<HashMap> list = notificationListCustomRepository.getCount(grade, LocalDateTime.parse(from_date + "T00:00:00"), LocalDateTime.parse(to_date + "T23:59:59"));
                    arr[grade-1] = (int) list.get(0).get("count");
                }
                NotificationMonthStatistics ns = new NotificationMonthStatistics(date, arr[0], arr[1], arr[2]);
                notificationMonthStatisticsRepository.save(ns);
            } catch (Exception e) {
//                log.info(e.getMessage());
            }
        } //if

    }
}