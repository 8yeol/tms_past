package com.example.tms.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@NoArgsConstructor
@Document(collection = "log")
public class Log {
    @Id
    private ObjectId _id;
    private String id;
    private String content;
    private String type;
    private Date date;

    public Log(String id, String content, String type){
        this.id = id;
        this.content = content;
        this.type = type;
    }
}
