package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document("collection = notification_list")
public class Notification_list {
    public ObjectId _id;
    public String place;
    public String sensor;
    public String notify;
    public String grade;
    public Date up_time;
}
