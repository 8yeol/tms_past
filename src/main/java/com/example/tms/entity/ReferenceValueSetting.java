package com.example.tms.entity;

import lombok.Builder;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "reference_value_setting")
public class ReferenceValueSetting {
    @Id
    private ObjectId _id;
    private String managementId;
    private String naming;
    private Float legalStandard;//법적기준
    private Float companyStandard;//사내기준
    private Float managementStandard; //관리기준
    private Boolean monitoring; //모니터링

    @Builder
    public ReferenceValueSetting(String managementId, String naming, Float legalStandard, Float companyStandard, Float managementStandard, Boolean monitoring) {
        this.managementId = managementId;
        this.naming = naming;
        this.legalStandard = legalStandard;
        this.companyStandard = companyStandard;
        this.managementStandard = managementStandard;
        this.monitoring = monitoring;
    }

    public ObjectId get_id() {
        return _id;
    }

    public void set_id(ObjectId _id) {
        this._id = _id;
    }

    public String getManagementId() {
        return managementId;
    }

    public void setManagementId(String managementId) {
        this.managementId = managementId;
    }

    public String getNaming() {
        return naming;
    }

    public void setNaming(String naming) {
        this.naming = naming;
    }

    public Float getLegalStandard() {
        return legalStandard;
    }

    public void setLegalStandard(Float legalStandard) {
        this.legalStandard = legalStandard;
    }

    public Float getCompanyStandard() {
        return companyStandard;
    }

    public void setCompanyStandard(Float companyStandard) {
        this.companyStandard = companyStandard;
    }

    public Float getManagementStandard() {
        return managementStandard;
    }

    public void setManagementStandard(Float managementStandard) {
        this.managementStandard = managementStandard;
    }

    public Boolean getMonitoring() {
        return monitoring;
    }

    public void setMonitoring(Boolean monitoring) {
        this.monitoring = monitoring;
    }

    @Override
    public String toString() {
        return "ReferenceValueSetting{" +
                "_id=" + _id +
                ", managementId='" + managementId + '\'' +
                ", naming='" + naming + '\'' +
                ", legalStandard=" + legalStandard +
                ", companyStandard=" + companyStandard +
                ", managementStandard=" + managementStandard +
                ", monitoring=" + monitoring +
                '}';
    }
}
