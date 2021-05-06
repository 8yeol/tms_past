package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "yearly_emissions")
public class YearlyEmissions {
    @Id
    private ObjectId _id;
    private String place;
    private String sensorNaming;
    public int standard;
    public int yearlyValue;

}
