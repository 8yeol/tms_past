package com.example.tms.entity;

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
    public String place; // 측정소 명
    public String sensor; // 센서명
    public float value;
    public int grade; // 관리 등급 ( 1 : 법적기준 초과, 2 : 사내기준 초과, 3 : 관리기준 초과)
    public String notify; // 초과 알림
    public Date up_time; // 업데이트 시간
}
