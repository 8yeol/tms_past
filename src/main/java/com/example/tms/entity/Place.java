package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "place")
@Data
public class Place {

    @Id
    private ObjectId _id;
    private String name;
    private String group;
    private String power;
    private List sensor;

}
