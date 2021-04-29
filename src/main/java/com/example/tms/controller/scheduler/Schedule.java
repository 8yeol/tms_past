package com.example.tms.controller.scheduler;

import com.example.tms.entity.Notification_Settings;
import com.example.tms.entity.Reference_Value_Setting;
import com.example.tms.entity.Sensor;
import com.example.tms.repository.Notification_SettingsRepository;
import com.example.tms.repository.Reference_Value_SettingRepository;
import com.example.tms.repository.SensorCustomRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

@Component
public class Schedule {

    final SensorCustomRepository sensorCustomRepository;

    final Notification_SettingsRepository notification_settingsRepository;

    final Reference_Value_SettingRepository reference_value_settingRepository;

    public Schedule(SensorCustomRepository sensorCustomRepository, Notification_SettingsRepository notification_settingsRepository, Reference_Value_SettingRepository reference_value_settingRepository) {
        this.sensorCustomRepository = sensorCustomRepository;
        this.notification_settingsRepository = notification_settingsRepository;
        this.reference_value_settingRepository = reference_value_settingRepository;
    }

    //@Scheduled(cron = "0/3 * * * * *")
    //@Scheduled(cron = "0 0/5 * * * *")
    public void scheduling(){
        List<Notification_Settings> notification = notification_settingsRepository.findByStatusIsTrue();

        for(int i=0; i<notification.size(); i++){
            String sensorName = notification.get(i).getName();
            Reference_Value_Setting reference = reference_value_settingRepository.findByName(sensorName);

            // 마지막 센서 값 받아오기
            Sensor sensor = sensorCustomRepository.getSensorRecent(sensorName);
            Float value = sensor.getValue();

            Float legal = reference.getLegal_standard(); // 법적기준
            Float company = reference.getCompany_standard(); //사내기준
            Float standard = reference.getManagement_standard(); //관리기준

            if(value > legal){
                System.out.println("legal");
            }else if(value > company){
                System.out.println("company");
            }else if( value >= standard){
                System.out.println("standard");
            }
        }
        System.out.println("스케쥴링 테스트 : " + new Date());
    }


}