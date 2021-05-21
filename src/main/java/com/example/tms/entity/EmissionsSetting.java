package com.example.tms.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@Document(collection = "emissions_sensor_setting")
public class EmissionsSetting {
    @Id
    private ObjectId _id;
    private String place;
    private String sensor;
    private String sensorNaming;
    private boolean status;

    public EmissionsSetting(String place, String sensor, String sensorNaming, boolean b) {
        this.place = place;
        this.sensor= sensor;
        this.sensorNaming =sensorNaming;
        this.status = b;
    }
}

