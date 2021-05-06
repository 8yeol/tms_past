package com.example.tms.entity;


import lombok.Builder;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "notification_settings")
public class NotificationSettings {

    @Id
    private ObjectId _id;
    private String name; //table name
    private String start; //알람 시작시간
    private String end; //알람 종료시간
    private boolean status; //on/off
    private Date up_time; //업데이트 시간

    public ObjectId get_id() {
        return _id;
    }

    public void set_id(ObjectId _id) {
        this._id = _id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getUp_time() {
        return up_time;
    }

    public void setUp_time(Date up_time) {
        this.up_time = up_time;
    }

    @Override
    public String toString() {
        return "Notification_Settings{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", start='" + start + '\'' +
                ", end='" + end + '\'' +
                ", status=" + status +
                ", up_time=" + up_time +
                '}';
    }
    @Builder
    public NotificationSettings(String name, String start, String end, boolean status, Date up_time){
        this.name = name;
        this.start = start;
        this.end = end;
        this.status = status;
        this.up_time = up_time;
    }
}
