package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "emissions_transition")
public class EmissionsTransition {
    @Id
    private ObjectId _id;
    private String tableName;
    private String placeName;
    private String sensorName;
    private int year;
    private int firstQuarter;
    private int secondQuarter;
    private int thirdQuarter;
    private int fourthQuarter;
    private int totalEmissions;
    public Date updateTime;
}
