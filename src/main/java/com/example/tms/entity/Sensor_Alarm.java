package com.example.tms.entity;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "sensor_alarm")
public class Sensor_Alarm {

    @Id
    private ObjectId _id;
    private String name;
    private String naming;
    private Date start;
    private Date end;
    private boolean status;
    private Date up_time;

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

    public String getNaming() {
        return naming;
    }

    public void setNaming(String naming) {
        this.naming = naming;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
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
        return "Sensor_alarm{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", naming='" + naming + '\'' +
                ", start=" + start +
                ", end=" + end +
                ", status=" + status +
                ", up_time=" + up_time +
                '}';
    }
}
