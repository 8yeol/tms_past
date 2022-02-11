package com.example.tms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
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
    public String classification;
    public String naming;
    public String managementId;
    public String tableName;
    @JsonFormat(timezone = "Asia/Seoul")
    public Date upTime;
    public String place;
    public int status1;
    public int status2;

    public SensorList(String classification, String naming, String managementId, String tableName, Date date, String place) {
        this.classification = classification;
        this.naming= naming;
        this.managementId =managementId;
        this.tableName= tableName;
        this.upTime = date;
        this.place = place;
    }
}
