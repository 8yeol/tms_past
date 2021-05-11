package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "item")
public class Item {
    @Id
    private ObjectId _id;
    private String item;
    private String itemName;
    private int emissionsStandard;
    private int densityStandard;
    private String formula;
}
