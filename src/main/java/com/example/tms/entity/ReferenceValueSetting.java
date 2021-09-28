package com.example.tms.entity;

import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "reference_value_setting")
public class ReferenceValueSetting {
    @Id
    private ObjectId _id;
    private String name; //테이블 명
    private String naming; //한글명
    private Float legalStandard;//법적기준
    private Float companyStandard;//사내기준
    private Float managementStandard; //관리기준
    private Float min; //
    private Float max; //
    private Boolean monitoring; //모니터링

    @Builder
    public ReferenceValueSetting(String name, String naming, Float legalStandard, Float companyStandard, Float managementStandard, Float min, Float max, Boolean monitoring) {
        this.name = name;
        this.naming = naming;
        this.legalStandard = legalStandard;
        this.companyStandard = companyStandard;
        this.managementStandard = managementStandard;
        this.monitoring = monitoring;
        this.min = min;
        this.max = max;
    }
}
