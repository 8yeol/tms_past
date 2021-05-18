package com.example.tms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@NoArgsConstructor
@Document(collection = "sensor")
public class SensorList {
    public ObjectId _id;
    public String classification; //분류
    public String naming; //한글명
    public String managementId; //관리아이디
    public String tableName; //테이블명
    @JsonFormat(timezone = "Asia/Seoul")
    public Date upTime; //업데이트 시간
    public String place; //측정소명
    public boolean status; //통신상태

    public SensorList(String classification, String naming, String managementId, String tableName, Date date, String place, boolean b) {
        this.classification = classification;
        this.naming= naming;
        this.managementId =managementId;
        this.tableName= tableName;
        this.upTime = date;
        this.place = place;
        this.status = b;

    }

    @Override
    public String toString() {
        return "SensorList{" +
                "_id=" + _id +
                ", classification='" + classification + '\'' +
                ", naming='" + naming + '\'' +
                ", managementId='" + managementId + '\'' +
                ", tableName='" + tableName + '\'' +
                ", upTime=" + upTime +
                ", place='" + place + '\'' +
                ", status=" + status +
                '}';
    }
}
