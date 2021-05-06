package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "y_emissions_sensor_setting")
public class YearlyEmissionsSetting {
    @Id
    private ObjectId _id;
    private String place;
    private String sensor;
    private String sensorNaming;
    private boolean status;
}
