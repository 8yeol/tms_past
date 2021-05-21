package com.example.tms.entity;

import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
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
}
