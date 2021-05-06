package com.example.tms.controller.scheduler;

import com.example.tms.entity.NotificationList;
import com.example.tms.entity.NotificationSettings;
import com.example.tms.entity.ReferenceValueSetting;
import com.example.tms.entity.Sensor;
import com.example.tms.repository.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

@Component
public class Schedule {

    final PlaceRepository placeRepository;
    final NotificationListRepository notificationListRepository;
    final SensorCustomRepository sensorCustomRepository;
    final NotificationSettingsRepository notification_settingsRepository;
    final ReferenceValueSettingRepository reference_value_settingRepository;

    public Schedule(SensorCustomRepository sensorCustomRepository, NotificationSettingsRepository notification_settingsRepository, ReferenceValueSettingRepository reference_value_settingRepository, PlaceRepository placeRepository, NotificationListRepository notificationListRepository) {
        this.sensorCustomRepository = sensorCustomRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
        this.placeRepository = placeRepository;
        this.notificationListRepository = notificationListRepository;
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

}