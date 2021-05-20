package com.example.tms.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@NoArgsConstructor
@Document(collection = "emissions_standard_setting")
public class EmissionsStandardSetting {
    @Id
    private ObjectId _id;
    private String place;
    private String naming;
    private int emissionsStandard;
    private int densityStandard;
    private String tableName;
    private String formula;
    private Date date;

    public EmissionsStandardSetting(String place, String naming, int emissionsStandard, int densityStandard, String tableName, String formula, Date date) {
        this.place = place;
        this.naming= naming;
        this.emissionsStandard= emissionsStandard;
        this.densityStandard= densityStandard;
        this.tableName= tableName;
        this.formula= formula;
        this.date = date;

    }
}
