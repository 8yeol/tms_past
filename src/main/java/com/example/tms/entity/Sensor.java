package com.example.tms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;

import java.util.Date;

@Data
public class Sensor {
    @Id
    private ObjectId _id;
    private float value;
    private boolean status;
    private int status1;
    private int status2;
    @JsonFormat(timezone = "Asia/Seoul")
    private Date up_time;
}
