package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "reference_value_setting")
@Data
public class Reference_Value_Setting {
    @Id
    private ObjectId _id;
    private String name;
    private String naming;
    private Float legal_standard;//법적기준
    private Float company_standard;//사내기준
    private Float management_standard; //관리기준
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

    public Float getLegal_standard() {
        return legal_standard;
    }

    public void setLegal_standard(Float legal_standard) {
        this.legal_standard = legal_standard;
    }

    public Float getCompany_standard() {
        return company_standard;
    }

    public void setCompany_standard(Float company_standard) {
        this.company_standard = company_standard;
    }

    public Float getManagement_standard() {
        return management_standard;
    }

    public void setManagement_standard(Float management_standard) {
        this.management_standard = management_standard;
    }

    public String getPower() {
        return power;
    }

    public void setPower(String power) {
        this.power = power;
    }

    @Builder
    public Reference_Value_Setting(String name, String naming, Float legal_standard, Float company_standard, Float management_standard, String power){
        this.name = name;
        this.naming = naming;
        this.legal_standard = legal_standard;
        this.company_standard = company_standard;
        this.management_standard = management_standard;
        this.power = power;
    }

    @Override
    public String toString() {
        return "Reference_Value_Setting{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", naming='" + naming + '\'' +
                ", legal_standard=" + legal_standard +
                ", company_standard=" + company_standard +
                ", management_standard=" + management_standard +
                ", power='" + power + '\'' +
                '}';
    }
}
