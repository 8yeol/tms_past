package com.example.tms.entity;


import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
import java.util.List;

@Document("stationManagement")
public class StationManagement {
    @Id
    private ObjectId _id;
    private String name; //측정소
    private boolean status; //모니터링사용
    private Date up_time; //업데이트시간
    private List sensor; //센서

    //embedded document
    private String sName; //측정항목
    private String sId; //관리ID
    private Double warning; //경고값
    private Double danger; //위험값
    private Double replace; //대체값
    private boolean sStatus; //모니터링사용

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

    public List getSensor() {
        return sensor;
    }

    public void setSensor(List sensor) {
        this.sensor = sensor;
    }

    public String getsName() {
        return sName;
    }

    public void setsName(String sName) {
        this.sName = sName;
    }

    public String getsId() {
        return sId;
    }

    public void setsId(String sId) {
        this.sId = sId;
    }

    public Double getWarning() {
        return warning;
    }

    public void setWarning(Double warning) {
        this.warning = warning;
    }

    public Double getDanger() {
        return danger;
    }

    public void setDanger(Double danger) {
        this.danger = danger;
    }

    public Double getReplace() {
        return replace;
    }

    public void setReplace(Double replace) {
        this.replace = replace;
    }

    public boolean issStatus() {
        return sStatus;
    }

    public void setsStatus(boolean sStatus) {
        this.sStatus = sStatus;
    }

    @Override
    public String toString() {
        return "SensorDetail{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", status=" + status +
                ", up_time=" + up_time +
                ", sensor=" + sensor +
                ", sName='" + sName + '\'' +
                ", sId='" + sId + '\'' +
                ", warning='" + warning + '\'' +
                ", danger='" + danger + '\'' +
                ", replace='" + replace + '\'' +
                ", sStatus=" + sStatus +
                '}';
    }
}
