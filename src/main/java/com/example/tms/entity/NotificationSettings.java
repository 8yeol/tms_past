package com.example.tms.entity;


import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "notification_settings")
public class NotificationSettings {
    @Id
    private ObjectId _id;
    private String name;
    private String start;
    private String end;
    private boolean status;
    private Date up_time;

    @Builder
    public NotificationSettings(String name, String start, String end, boolean status, Date up_time){
        this.name = name;
        this.start = start;
        this.end = end;
        this.status = status;
        this.up_time = up_time;
    }
}
