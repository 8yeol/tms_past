package com.example.tms.controller.scheduler;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.AnnualEmissionsRepository;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsCustomRepository;
import com.example.tms.repository.MonthlyEmissions.MonthlyEmissionsRepository;
import com.example.tms.repository.NotificationStatistics.NotificationDayStatisticsRepository;
import com.example.tms.repository.NotificationList.NotificationListCustomRepository;
import com.example.tms.repository.NotificationStatistics.NotificationMonthStatisticsRepository;
import com.example.tms.repository.PlaceRepository;
import com.example.tms.repository.SensorListRepository;
import org.springframework.beans.factory.annotation.Autowired;
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
    final PlaceRepository placeRepository;
    final MongoQuary mongoQuary;
    final AnnualEmissionsRepository annualEmissionsRepository;


    public Schedule(NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, NotificationListCustomRepository notificationListCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, MonthlyEmissionsCustomRepository monthlyEmissionsCustomRepository, SensorListRepository sensorListRepository, PlaceRepository placeRepository, MongoQuary mongoQuary, AnnualEmissionsRepository annualEmissionsRepository) {
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.monthlyEmissionsRepository = monthlyEmissionsRepository;
        this.monthlyEmissionsCustomRepository = monthlyEmissionsCustomRepository;
        this.sensorListRepository = sensorListRepository;
        this.placeRepository = placeRepository;
        this.mongoQuary = mongoQuary;
        this.annualEmissionsRepository = annualEmissionsRepository;
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

    /**
     * [대시보드 - 연간 배출량 누적 모니터링]
     *
     * (알림 현황 전날(day) 이번달(month) 데이터 입력 ※매달 1일은 지난달로 계산)
     */
    @Scheduled(cron = "0 0 1 * * *") //매일 01시 00분에 처리
    //@Scheduled(cron = "*/10 * * * * *") // 10초마다 테스트
    public void saveCumulativeEmissions(){
        // 질소산화물(NOX) : Map<측정소명, 테이블명> 형식
        Map<String, String> noxList = new HashMap<>();
        for( SensorList sensorList : sensorListRepository.findByClassification("NOX")){
            noxList.put(sensorList.getPlace(), sensorList.getTableName());
        }

        // 유량(FL1) : Map<측정소명, 테이블명> 형식
        Map<String, String> fl1List = new HashMap<>();
        for( SensorList sensorList : sensorListRepository.findByClassification("FL1")){
            fl1List.put(sensorList.getPlace(), sensorList.getTableName());
        }

        // 전체 측정소 리스트를 불러와서 30분 평균 데이터가 저장되는 DB 조회(실시간 데이터 테이블 앞에 RM30_ 붙여주면 30분 평균데이터 조회 가능)
        String halfPast = "RM30_";
        for( Place place : placeRepository.findAll()){
            String placeName = place.getName();
            // 해당 측정소에 nox 데이터와 fl1 데이터가 있는경우 아래로직 실행 (측정소에 맵핑 되어 있지않은경우 해당 질소산화물 데이터와 유량값이 어떤 측정소에 해당하는 데이터인지 알수없기때문에 구현X)
            if(noxList.get(placeName)!=null && fl1List.get(placeName)!=null){
                //계산하려면 질소산화물 값이랑 유량값 둘다 필요하기때문에 둘다 null 이 아닌경우 계산식 실행
                String noxTable = halfPast + noxList.get(placeName);
                String fl1Table = halfPast + fl1List.get(placeName);

                //해당 테이블 값으로 전일 30분 평균데이터들 조회
                LocalDate nowDate = LocalDate.now();
                LocalDate yesterday = nowDate.minusDays(1);
                List<ChartData> noxData = (List<ChartData>) mongoQuary.getCumulativeEmissions(noxTable, yesterday);
                List<ChartData> fl1Data = (List<ChartData>) mongoQuary.getCumulativeEmissions(fl1Table, yesterday);
                double emissions = 0;
                if(noxData.size()==48 && fl1Data.size()==48){
                    for(int i = 0 ; i < noxData.size(); i++){
                        emissions += noxData.get(i).getY() * fl1Data.get(i).getY() / 1000 * 46 / 22.4;
                    }
                }else{ 
                    // 데이터가 올바르게 전부 들어오지 않은 경우 로직 (?)
                }
                AnnualEmissions annualEmissions = annualEmissionsRepository.findBySensor(noxList.get(placeName));
                // 오늘 날짜 체크해서 1월 1일인 경우 데이터 0으로 초기화
                int yearlyValue = annualEmissions.getYearlyValue();
                annualEmissions.setYearlyValue(yearlyValue + (int) emissions);
                annualEmissionsRepository.save(annualEmissions);
            }
        }
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