package com.example.tms.controller.scheduler;

import com.example.tms.entity.*;
import com.example.tms.mongo.MongoQuary;
import com.example.tms.repository.AnnualEmissionsRepository;
import com.example.tms.repository.EmissionsTransitionRepository;
import com.example.tms.repository.MonthlyEmissionsRepository;
import com.example.tms.repository.NotificationStatistics.NotificationDayStatisticsRepository;
import com.example.tms.repository.NotificationList.NotificationListCustomRepository;
import com.example.tms.repository.NotificationStatistics.NotificationMonthStatisticsRepository;
import com.example.tms.repository.PlaceRepository;
import com.example.tms.repository.SensorListRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Component
public class Schedule {

    final NotificationDayStatisticsRepository notificationDayStatisticsRepository;
    final NotificationMonthStatisticsRepository notificationMonthStatisticsRepository;
    final NotificationListCustomRepository notificationListCustomRepository;
    final MonthlyEmissionsRepository monthlyEmissionsRepository;
    final SensorListRepository sensorListRepository;
    final PlaceRepository placeRepository;
    final MongoQuary mongoQuary;
    final AnnualEmissionsRepository annualEmissionsRepository;
    final EmissionsTransitionRepository emissionsTransitionRepository;

    public Schedule(NotificationDayStatisticsRepository notificationDayStatisticsRepository, NotificationMonthStatisticsRepository notificationMonthStatisticsRepository, NotificationListCustomRepository notificationListCustomRepository, MonthlyEmissionsRepository monthlyEmissionsRepository, SensorListRepository sensorListRepository, PlaceRepository placeRepository, MongoQuary mongoQuary, AnnualEmissionsRepository annualEmissionsRepository, EmissionsTransitionRepository emissionsTransitionRepository) {
        this.notificationDayStatisticsRepository = notificationDayStatisticsRepository;
        this.notificationMonthStatisticsRepository = notificationMonthStatisticsRepository;
        this.notificationListCustomRepository = notificationListCustomRepository;
        this.monthlyEmissionsRepository = monthlyEmissionsRepository;
        this.sensorListRepository = sensorListRepository;
        this.placeRepository = placeRepository;
        this.mongoQuary = mongoQuary;
        this.annualEmissionsRepository = annualEmissionsRepository;
        this.emissionsTransitionRepository = emissionsTransitionRepository;
    }

    /**
     * [알림 - 센서 알림현황]
     * 기준 초과 알림 목록을 읽어와 기준별 카운트하여 일별/월별로 해당 컬렉션에 저장
     * (알림 현황 전날(day) 이번달(month) 데이터 입력 ※매달 1일은 지난달로 계산)
     */
    @Scheduled(cron = "0 1 0 * * *") //매일 00시 01분에 처리
    public void saveNotificationStatistics(){
        // 일
        LocalDate nowDate = LocalDate.now();
        // 어제 날짜 불러오기
        LocalDate yesterday = nowDate.minusDays(1);

        List<Place> placeList = placeRepository.findAll();
        for(Place place : placeList){
            String placeName = place.getName();
            NotificationDayStatistics yesterdayData = notificationDayStatisticsRepository.findByDayAndPlace(String.valueOf(yesterday), placeName);

            // 어제 날짜 데이터가 없는 경우 new 객체 생성 후 데이터 set
            if(yesterdayData == null){
                yesterdayData = new NotificationDayStatistics();
            }
            yesterdayData.setDay(String.valueOf(yesterday));

            int[] dayValue = getReferenceValueCount(String.valueOf(yesterday), String.valueOf(yesterday), placeName);
            yesterdayData.setLegalCount(dayValue[0]);
            yesterdayData.setCompanyCount(dayValue[1]);
            yesterdayData.setManagementCount(dayValue[2]);
            yesterdayData.setPlace(placeName);
            notificationDayStatisticsRepository.save(yesterdayData);

            // 월
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

            NotificationMonthStatistics monthData = notificationMonthStatisticsRepository.findByMonthAndPlace(year_month, placeName);
            if(monthData == null){
                monthData = new NotificationMonthStatistics();
            }
            monthData.setMonth(year_month);

            int[] monthValue = getReferenceValueCount(String.valueOf(from), String.valueOf(to), placeName);
            monthData.setLegalCount(monthValue[0]);
            monthData.setCompanyCount(monthValue[1]);
            monthData.setManagementCount(monthValue[2]);
            monthData.setPlace(placeName);
            notificationMonthStatisticsRepository.save(monthData);
        }
    }

    public int[] getReferenceValueCount(String from, String to, String place){
        int[] arr = new int[3];
        for(int grade=1; grade<=3; grade++) {
            List<HashMap> list = notificationListCustomRepository.getCount(grade, from, to, place);
            if (list.size() != 0) {
                arr[grade - 1] = (int) list.get(0).get("count");
            } else {
                arr[grade - 1] = 0;
            }
        }
        return arr;
    }

    /**
     * [대시보드 - 연간 배출량 누적 모니터링]
     *
     * (알림 현황 전날(day) 이번달(month) 데이터 입력 ※매달 1일은 지난달로 계산)
     */
    @Scheduled(cron = "0 0 0 * * *") //매일 자정 실행
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
                String noxTable = noxList.get(placeName);
                String fl1Table = fl1List.get(placeName);

                LocalDate nowDate = LocalDate.now();
                LocalDate yesterday = nowDate.minusDays(1);

                // 질소산화물 전일 배출량
                double emissions = getNOXYesterdayEmissions(yesterday, halfPast + noxTable, halfPast + fl1Table);

                // [분석 및 통계 - 통계자료 조회] 월별 배출량 추이
                setMonthlyEmissions(yesterday, noxTable, emissions);
            }
        }
    }

    // nox 전일 배출량 계산 (계산식 확인 필요)
    public double getNOXYesterdayEmissions(LocalDate yesterday, String nox, String fl1){
        List<ChartData> noxData = (List<ChartData>) mongoQuary.getCumulativeEmissions(nox, yesterday);
        List<ChartData> fl1Data = (List<ChartData>) mongoQuary.getCumulativeEmissions(fl1, yesterday);
        double emissions = 0;

        // 데이터가 올바르게 들어오는지 체크하기 위한 로직 (정밀 계산시 BigDecimal 사용, 현재 일반 사칙연산으로도 연산 처리 문제 없음)
        if(noxData.size()==48 && fl1Data.size()==48){
            for(int i = 0 ; i < noxData.size(); i++){
                // 마지막 /1000은 kg 으로 한산해주기 위함 (기존단위 g)
                emissions += noxData.get(i).getY() * fl1Data.get(i).getY() / 1000 * 46 / 22.4 / 1000;
            /*
            BigDecimal noxValue = new BigDecimal(noxData.get(i).getY());
            BigDecimal fl1Value = new BigDecimal(fl1Data.get(i).getY());
            BigDecimal test = noxValue.multiply(fl1Value).divide(new BigDecimal(1000)).multiply(new BigDecimal(46));
            BigDecimal test2 = test.divide(new BigDecimal(22.4), 2, BigDecimal.ROUND_CEILING);
            */
            }
        }else{

        }

        return emissions;
    }

    // [분석 및 통계 - 통계자료 조회] 월별 배출량 추이
    public void setMonthlyEmissions(LocalDate yesterday, String table, double emissions){
        int year = yesterday.getYear();

        MonthlyEmissions monthlyEmissions = monthlyEmissionsRepository.findBySensorAndYear(table, year);

        // 당해년도 데이터가 없는경우 새로 생성
        if(monthlyEmissions == null){
            monthlyEmissions = new MonthlyEmissions();
            monthlyEmissions.setSensor(table);
            monthlyEmissions.setYear(year);
        }

        switch(yesterday.getMonthValue()) {
            case 1:
                monthlyEmissions.setJan((monthlyEmissions.getJan() == null ? 0 : monthlyEmissions.getJan()) + emissions);
                break;
            case 2:
                monthlyEmissions.setFeb((monthlyEmissions.getFeb() == null ? 0 : monthlyEmissions.getFeb()) + emissions);
                break;
            case 3:
                monthlyEmissions.setMar((monthlyEmissions.getMar() == null ? 0 : monthlyEmissions.getMar()) + emissions);
                break;
            case 4:
                monthlyEmissions.setApr((monthlyEmissions.getApr() == null ? 0 : monthlyEmissions.getApr()) + emissions);
                break;
            case 5:
                monthlyEmissions.setMay((monthlyEmissions.getMay() == null ? 0 : monthlyEmissions.getMay()) + emissions);
                break;
            case 6:
                monthlyEmissions.setJun((monthlyEmissions.getJun() == null ? 0 : monthlyEmissions.getJun()) + emissions);
                break;
            case 7:
                monthlyEmissions.setJul((monthlyEmissions.getJul() == null ? 0 : monthlyEmissions.getJul()) + emissions);
                break;
            case 8:
                monthlyEmissions.setAug((monthlyEmissions.getAug() == null ? 0 : monthlyEmissions.getAug()) + emissions);
                break;
            case 9:
                monthlyEmissions.setSep((monthlyEmissions.getSep() == null ? 0 : monthlyEmissions.getSep()) + emissions);
                break;
            case 10:
                monthlyEmissions.setOct((monthlyEmissions.getOct() == null ? 0 : monthlyEmissions.getOct()) + emissions);
                break;
            case 11:
                monthlyEmissions.setNov((monthlyEmissions.getNov() == null ? 0 : monthlyEmissions.getNov()) + emissions);
                break;
            case 12:
                monthlyEmissions.setDec((monthlyEmissions.getDec() == null ? 0 : monthlyEmissions.getDec()) + emissions);
                break;
        }

        monthlyEmissions.setUpdateTime(new Date());
        monthlyEmissionsRepository.save(monthlyEmissions);

        // [대시보드] 연간 배출량 누적 모니터링
        setAnnualEmissions(table);

        // [대시보드] 연간 배출량 추이 모니터링
        setEmissionsTransition(yesterday, table);
    }

    // 연간 배출량 누적 모니터링
    public void setAnnualEmissions(String table){
        LocalDate nowDate = LocalDate.now();
        LocalDate yesterday = nowDate.minusDays(1);
        int year = yesterday.getYear();

        AnnualEmissions annualEmissions = annualEmissionsRepository.findBySensor(table);
        String format = nowDate.format(DateTimeFormatter.ofPattern("MMdd"));

        // 오늘 날짜가 1월 1일인 경우 데이터 초기화 하고 전일 데이터는 저장(분석 및 통계 - 통계자료 조회에 활용)
        if(format.equals("0101")){
            annualEmissions.setYearlyValue(0);
        }else{
            MonthlyEmissions monthlyEmissions = monthlyEmissionsRepository.findBySensorAndYear(table, year);
            double total = monthlyEmissions.getJan() + monthlyEmissions.getFeb() + monthlyEmissions.getMar() + monthlyEmissions.getApr() + monthlyEmissions.getMay()
                    + monthlyEmissions.getJun() + monthlyEmissions.getJul() + monthlyEmissions.getAug() + monthlyEmissions.getSep() + monthlyEmissions.getOct()
                    + monthlyEmissions.getNov() + monthlyEmissions.getDec();
            annualEmissions.setYearlyValue((int) total);
        }
        annualEmissions.setUpdateTime(new Date());
        annualEmissionsRepository.save(annualEmissions);
    }

    // 연간 배출량 추이 모니터링
    public void setEmissionsTransition(LocalDate yesterday, String table){
        int year = yesterday.getYear();
        EmissionsTransition emissionsTransition = emissionsTransitionRepository.findByTableNameAndYearEquals(table, year);

        if(emissionsTransition==null){
            SensorList sensorList = sensorListRepository.findByTableName(table);

            EmissionsTransition newEmissionsTransition = new EmissionsTransition();
            newEmissionsTransition.setTableName(table);
            newEmissionsTransition.setPlaceName(sensorList.getPlace());
            newEmissionsTransition.setSensorName(sensorList.getNaming());
            newEmissionsTransition.setYear(year);
            newEmissionsTransition.setFirstQuarter(0);
            newEmissionsTransition.setSecondQuarter(0);
            newEmissionsTransition.setThirdQuarter(0);
            newEmissionsTransition.setFourthQuarter(0);
            newEmissionsTransition.setTotalEmissions(0);

            emissionsTransitionRepository.save(newEmissionsTransition);

            emissionsTransition = emissionsTransitionRepository.findByTableNameAndYearEquals(table, year);
        }

        int quarter = (int) Math.ceil( yesterday.getMonthValue() / 3.0 );

        MonthlyEmissions monthlyEmissions = monthlyEmissionsRepository.findBySensorAndYear(table, year);
        double emissions = 0;
        switch(quarter) {
            case 1:
                double firstQuarter = monthlyEmissions.getJan() + monthlyEmissions.getFeb() + monthlyEmissions.getMar();
                emissionsTransition.setFirstQuarter((int) firstQuarter);
                emissions = firstQuarter;
                break;
            case 2:
                double secondQuarter = monthlyEmissions.getApr() + monthlyEmissions.getMay() + monthlyEmissions.getJun();
                emissionsTransition.setSecondQuarter((int) secondQuarter);
                emissions = secondQuarter;
                break;
            case 3:
                double thirdQuarter = monthlyEmissions.getJul() + monthlyEmissions.getAug() + monthlyEmissions.getSep();
                emissionsTransition.setThirdQuarter((int) thirdQuarter);
                emissions = thirdQuarter;
                break;
            case 4:
                double fourthQuarter = monthlyEmissions.getOct() + monthlyEmissions.getNov() + monthlyEmissions.getDec();
                emissionsTransition.setFourthQuarter((int) fourthQuarter);
                emissions = fourthQuarter;
                break;
        }

        int totalEmissions = emissionsTransition.getTotalEmissions() + (int) emissions;

        emissionsTransition.setTotalEmissions(totalEmissions);
        emissionsTransition.setUpdateTime(new Date());

        emissionsTransitionRepository.save(emissionsTransition);
    }

}