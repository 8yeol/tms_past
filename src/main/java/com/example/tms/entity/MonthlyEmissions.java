package com.example.tms.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "monthly_emissions")
public class MonthlyEmissions {
    @Id
    public Object _id;
    public String sensor;
    public int year;
    public Double jan;
    public Double feb;
    public Double mar;
    public Double apr;
    public Double may;
    public Double jun;
    public Double jul;
    public Double aug;
    public Double sep;
    public Double oct;
    public Double nov;
    public Double dec;
}