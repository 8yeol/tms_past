package com.example.tms.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "emissions_transition")
@AllArgsConstructor
@NoArgsConstructor
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

    public EmissionsTransition(String tableName, String placeName, String sensorName, int year, int firstQuarter, int secondQuarter,
                               int thirdQuarter, int fourthQuarter, int totalEmissions, Date updateTime) {
        this.tableName = tableName;
        this.placeName = placeName;
        this.sensorName = sensorName;
        this.year = year;
        this.firstQuarter = firstQuarter;
        this.secondQuarter = secondQuarter;
        this.thirdQuarter = thirdQuarter;
        this.fourthQuarter = fourthQuarter;
        this.totalEmissions = totalEmissions;
        this.updateTime = updateTime;
    }
}
