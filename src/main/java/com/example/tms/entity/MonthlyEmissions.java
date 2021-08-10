package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document(collection = "monthly_emissions")
public class MonthlyEmissions {
    @Id
    public ObjectId _id;
    public String sensor;
    public int year;
    public int jan;
    public int feb;
    public int mar;
    public int apr;
    public int may;
    public int jun;
    public int jul;
    public int aug;
    public int sep;
    public int oct;
    public int nov;
    public int dec;
    public Date updateTime;
}
