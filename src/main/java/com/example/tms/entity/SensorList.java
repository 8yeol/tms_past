package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "sensor")
public class SensorList {
    public ObjectId _id;
    public String classification;
    public String naming;
    public String managementId;
    public String tableName;
    public Date upTime;
    public String place;
    public boolean status;
}
