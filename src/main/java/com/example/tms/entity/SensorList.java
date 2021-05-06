package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "sensor")
public class SensorList {
    public ObjectId _id;
    public String classification; //분류
    public String naming; //한글명
    public String managementId; //관리아이디
    public String tableName; //테이블명
    public Date upTime; //업데이트 시간
    public String place; //측정소명
    public boolean status; //통신상태

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
