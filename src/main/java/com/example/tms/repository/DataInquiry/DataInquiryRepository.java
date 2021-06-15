package com.example.tms.repository.DataInquiry;

import com.example.tms.entity.Sensor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Repository
public class DataInquiryRepository {
    final MongoTemplate mongoTemplate;

    public DataInquiryRepository(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * [분석 및 통계 - 측정자료 조회] 페이지의 차트
     * @param date_start 검색 시작 일자
     * @param date_end 검색 종료 일자
     * @param item 테이블명
     * @param off off 데이터 표시 여부
     * @return 해당 기간 내의 센서 정보 리스트 ( 아래의 searchInformation 과 따로 구현한 이유는 off 데이터 null 처리 및 차트 데이터 형식에 맞게 가공하기 위함(리턴 형식 x,y) )
     */
    public List<HashMap> searchChart(String date_start, String date_end, String item, boolean off) {

        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("x")
                .and("value").as("y")
                .and("status").as("status");

        MatchOperation where = Aggregation.match(
                new Criteria().andOperator(
                        Criteria.where("x")
                                .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                )
        );
        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "x");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                sort
        );

        String tableName = getDiffDay(date_start, date_end, item);

        AggregationResults<HashMap> results = mongoTemplate.aggregate(agg, tableName, HashMap.class);

        List<HashMap> result = results.getMappedResults();

        if(off == false){
            for(HashMap map : result){
                if(map.get("status").equals(false)){
                    map.put("y",null);
                }
            }
        }
        return result;
    }

    /**
     * [분석 및 통계 - 측정자료 조회] 페이지의 상세보기(표)
     * @param date_start 검색 시작 날짜
     * @param date_end 검색 종료 날짜
     * @param item 테이블명
     * @param off off 데이터 표시할건지 여부
     * @return 해당 기간내의 센서 정보 리스트
     */
    public List<Sensor> searchInformatin(String date_start, String date_end, String item, boolean off) {
        ProjectionOperation dateProjection = Aggregation.project()
                .and("up_time").as("up_time")
                .and("value").as("value")
                .and("status").as("status");

        MatchOperation where;

        if (off == true) {
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("up_time")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        } else {
            where = Aggregation.match(
                    new Criteria().andOperator(
                            Criteria.where("status")
                                    .is(true)
                                    .and("up_time")
                                    .gte(LocalDateTime.parse(date_start + "T00:00:00"))
                                    .lte(LocalDateTime.parse(date_end + "T23:59:59"))
                    )
            );
        }

        SortOperation sort = Aggregation.sort(Sort.Direction.DESC, "up_time");

        Aggregation agg = Aggregation.newAggregation(
                dateProjection,
                where,
                sort
        );

        String tableName = getDiffDay(date_start, date_end, item);

        AggregationResults<Sensor> results = mongoTemplate.aggregate(agg, tableName, Sensor.class);

        List<Sensor> result = results.getMappedResults();

        return result;
    }

    /**
     * 두 날짜 차이 계산해서 7일 초과이면 30분 평균 데이터 연산, 이하이면 5분 평균 데이터로 연산
     * @param from 검색 시작날짜
     * @param to 검색 종료날짜
     * @param item table Name
     * @return 테이블명 (7분 미만일 경우 5분 평균 테이블명, 7분 이상일 경우 30분 평균 테이블명 리턴)
     */
    public String getDiffDay(String from, String to, String item){
        try {
            Date s_day = new SimpleDateFormat("yyyy-MM-dd").parse(from);
            Date e_day = new SimpleDateFormat("yyyy-MM-dd").parse(to);

            long diff = (e_day.getTime()- s_day.getTime()) / (24*60*60*1000);

            if(diff >= 7){
                item = "RM30_" + item;
            }else{
                item = "RM05_" + item;
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return item;
    }
}
