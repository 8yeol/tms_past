package com.example.tms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class ChartData {
    @JsonFormat(timezone = "Asia/Seoul")
    private Date x;
    private float y;
}
