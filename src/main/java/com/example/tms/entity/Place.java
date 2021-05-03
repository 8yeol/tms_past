package com.example.tms.entity;

import lombok.Builder;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
import java.util.List;

@Document(collection = "place")
public class Place {

    @Id
    private ObjectId _id;
    private String name;
    private String location;
    private String admin;
    private String tel;
    private String power;
    private Date up_time;
    private List sensor;

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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getAdmin() {
        return admin;
    }

    public void setAdmin(String admin) {
        this.admin = admin;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getPower() {
        return power;
    }

    public void setPower(String power) {
        this.power = power;
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

    @Override
    public String toString() {
        return "Place{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", admin='" + admin + '\'' +
                ", tel='" + tel + '\'' +
                ", power='" + power + '\'' +
                ", up_time=" + up_time +
                ", sensor=" + sensor +
                '}';
    }
    @Builder
    public Place(String name, String location,String admin,String tel,String power,Date up_time, List sensor){
        this.name = name;
        this.location = location;
        this.admin = admin;
        this.tel = tel;
        this.power = power;
        this.up_time = up_time;
        this.sensor = sensor;

    }
}
