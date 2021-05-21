package com.example.tms.entity;

import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "notification_day_statistics")
public class NotificationDayStatistics {
    @Id
    private ObjectId _id;
    private String day;
    private int legalCount;
    private int companyCount;
    private int managementCount;
    @Builder
    public NotificationDayStatistics(String day, int legalCount, int companyCount, int managementCount) {
        this.day = day;
        this.legalCount = legalCount;
        this.companyCount = companyCount;
        this.managementCount = managementCount;
    }
}
