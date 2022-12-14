package com.example.tms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "notification_list")
public class NotificationList1 {
    @Id
    public ObjectId _id;
    public String place;
    public String sensor;
    public String name;
    public String value;
    public int grade;
    @JsonFormat(timezone = "Asia/Seoul")
    public Date up_time;

    @Builder
    public NotificationList1(String place, String sensor, String name, String value, int grade, Date up_time) {
        this.place = place;
        this.sensor = sensor;
        this.name = name;
        this.value = value;
        this.grade = grade;
        this.up_time = up_time;
    }
}
