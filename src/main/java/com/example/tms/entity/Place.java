package com.example.tms.entity;

import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
import java.util.List;

@Data
@Document(collection = "place")
public class Place {
    @Id
    private ObjectId _id;
    private String name;
    private String location;
    private String admin;
    private String tel;
    private Boolean monitoring;
    private Date up_time;
    private List sensor;

    @Builder
    public Place(String name, String location, String admin, String tel, Boolean monitoring, Date up_time, List sensor) {
        this.name = name;
        this.location = location;
        this.admin = admin;
        this.tel = tel;
        this.monitoring = monitoring;
        this.up_time = up_time;
        this.sensor = sensor;
    }
}
