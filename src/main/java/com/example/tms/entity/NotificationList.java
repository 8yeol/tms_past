package com.example.tms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "notification_list")
public class NotificationList {
    @Id
    public ObjectId _id;
    public String place;
    public String sensor;
    public float value;
    public int grade;
    public String notify;
    @JsonFormat(timezone = "Asia/Seoul")
    public Date up_time;
}
