package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "notification_month_statistics")
public class NotificationMonthStatistics {
    @Id
    private ObjectId _id;
    private String place;
    private String month;
    private int legalCount;
    private int companyCount;
    private int managementCount;
}
