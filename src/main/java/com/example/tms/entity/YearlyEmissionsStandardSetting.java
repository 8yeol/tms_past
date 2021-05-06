package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "y_emissions_standard_setting")
public class YearlyEmissionsStandardSetting {
    @Id
    private ObjectId _id;
    private String sensorCode;
    private String sensorNaming;
    private int yearlyStandard;
    private int percent;
    private String formula;
}
