package com.example.tms.entity;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "tmsWP0004_NOx_01")
public class Sensor {

    @Id
    private ObjectId _id;
    private float value;
    private boolean status;
    private Date up_time;

    @Override
    public String toString() {
        return "Sensor{" +
                "_id=" + _id +
                ", value=" + value +
                ", status=" + status +
                ", up_time='" + up_time + '\'' +
                '}';
    }

    public ObjectId get_id() {
        return _id;
    }

    public void set_id(ObjectId _id) {
        this._id = _id;
    }

    public float getValue() {
        return value;
    }

    public void setValue(float value) {
        this.value = value;
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
}
