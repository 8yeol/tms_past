package com.example.tms.entity;

import lombok.Builder;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "notification_month_statistics")
public class NotificationMonthStatistics {

    @Id
    private ObjectId _id;
    private String month;
    private int legalCount;
    private int companyCount;
    private int managementCount;

    @Builder
    public NotificationMonthStatistics(String month, int legalCount, int companyCount, int managementCount) {
        this.month = month;
        this.legalCount = legalCount;
        this.companyCount = companyCount;
        this.managementCount = managementCount;
    }

    public ObjectId get_id() {
        return _id;
    }

    public void set_id(ObjectId _id) {
        this._id = _id;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public int getLegalCount() {
        return legalCount;
    }

    public void setLegalCount(int legalCount) {
        this.legalCount = legalCount;
    }

    public int getCompanyCount() {
        return companyCount;
    }

    public void setCompanyCount(int companyCount) {
        this.companyCount = companyCount;
    }

    public int getManagementCount() {
        return managementCount;
    }

    public void setManagementCount(int managementCount) {
        this.managementCount = managementCount;
    }
}
