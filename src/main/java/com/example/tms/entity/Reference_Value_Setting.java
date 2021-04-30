package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "reference_value_setting")
@Data
public class Reference_Value_Setting {
    @Id
    private ObjectId _id;
    private String name;
    private String naming;
    private Float legal_standard;//법적기준
    private Float company_standard;//사내기준
    private Float management_standard; //관리기준
    private String power; //모니터링
}
