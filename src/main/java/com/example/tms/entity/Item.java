package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document("item")
public class Item {
    public ObjectId _id;
    public String classification;
    public String naming;
}
