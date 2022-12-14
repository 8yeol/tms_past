package com.example.tms.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@NoArgsConstructor
@Document(collection = "annual_emissions")
public class AnnualEmissions {
    @Id
    private ObjectId _id;
    private String place;
    private String sensor;
    private String sensorNaming;
    private int yearlyValue;
    private boolean status;
    public Date updateTime;

    public AnnualEmissions(String place, String sensor, String sensorNaming, int yearlyValue, boolean status, Date updateTime) {
        this.place = place;
        this.sensor= sensor;
        this.sensorNaming =sensorNaming;
        this.yearlyValue= yearlyValue;
        this.status = status;
        this.updateTime = updateTime;
    }
}
