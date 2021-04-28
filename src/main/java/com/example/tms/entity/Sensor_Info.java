package com.example.tms.entity;

import lombok.Builder;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document(collection = "sensor_info")
public class Sensor_Info {

    @Id
    private ObjectId _id;
    private String name;
    private String naming;
    private Double legal_standard;//법적기준
    private Double company_standard;//사내기준
    private Double management_standard; //관리기준
    private String power; //모니터링


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

    public Double getLegal_standard() {
        return legal_standard;
    }

    public void setLegal_standard(Double legal_standard) {
        this.legal_standard = legal_standard;
    }

    public Double getCompany_standard() {
        return company_standard;
    }

    public void setCompany_standard(Double company_standard) {
        this.company_standard = company_standard;
    }

    public Double getManagement_standard() {
        return management_standard;
    }

    public void setManagement_standard(Double management_standard) {
        this.management_standard = management_standard;
    }

    public String getPower() {
        return power;
    }

    public void setPower(String power) {
        this.power = power;
    }

    @Override
    public String toString() {
        return "Sensor_Info{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", naming='" + naming + '\'' +
                ", legal_standard=" + legal_standard +
                ", company_standard=" + company_standard +
                ", management_standard=" + management_standard +
                ", power='" + power + '\'' +
                '}';
    }
    @Builder
    public Sensor_Info(String name, String naming, Double legal_standard, Double company_standard, Double management_standard, String power){
        this.name = name;
        this.naming = naming;
        this.legal_standard = legal_standard;
        this.company_standard = company_standard;
        this.management_standard = management_standard;
        this.power = power;

    }

}
