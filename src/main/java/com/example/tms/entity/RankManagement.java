package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "rank_management")
public class RankManagement {
    @Id
    private ObjectId _id;
    private String name;
    private boolean dashboard;
    private boolean alarm;
    private boolean monitoring;
    private boolean statistics;
    private boolean setting;
}
