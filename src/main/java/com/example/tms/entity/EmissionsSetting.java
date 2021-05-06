package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "emissions_sensor_setting")
public class EmissionsSetting {
    @Id
    private ObjectId _id;
    private String place;
    private String sensor;
    private String sensorNaming;
    private boolean status;
}
