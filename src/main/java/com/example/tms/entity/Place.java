package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;
@Document(collection = "place")
public class Place {

    @Id
    private ObjectId _id;
    private String name;
    private String group;
    private String power;
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

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getPower() {
        return power;
    }

    public void setPower(String power) {
        this.power = power;
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
                ", group='" + group + '\'' +
                ", power='" + power + '\'' +
                ", sensor=" + sensor +
                '}';
    }
}
