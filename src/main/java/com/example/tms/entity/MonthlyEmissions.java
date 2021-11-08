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

    public MonthlyEmissions(String sensor, int year, int jan, int feb, int mar, int apr, int may, int jun, int jul, int aug, int sep, int oct, int nov, int dec, Date updateTime) {
        this.sensor= sensor;
        this.year =year;
        this.jan= jan;
        this.feb = feb;
        this.mar = mar;
        this.apr = apr;
        this.may = may;
        this.jun = jun;
        this.jul = jul;
        this.aug = aug;
        this.sep = sep;
        this.oct = oct;
        this.nov = nov;
        this.dec = dec;
        this.updateTime = updateTime;
    }
}
