package com.example.tms.entity;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "sensor_info")
public class Sensor_Info {

    @Id
    private ObjectId _id;
    private String name;
    private String naming;
    private float warning;
    private float danger;
    private float substituion; //교정값

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

    public float getWarning() {
        return warning;
    }

    public void setWarning(float warning) {
        this.warning = warning;
    }

    public float getDanger() {
        return danger;
    }

    public void setDanger(float danger) {
        this.danger = danger;
    }

    public float getSubstituion() {
        return substituion;
    }

    public void setSubstituion(float substituion) {
        this.substituion = substituion;
    }
}