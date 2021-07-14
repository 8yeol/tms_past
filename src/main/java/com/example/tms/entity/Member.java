package com.example.tms.entity;

import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Date;

@Data
@Document(collection = "member")
public class Member {
    @Id
    private ObjectId _id;
    private String id;
    private String password;
    private String name;
    private String email;
    private String tel;
    private Date joined;
    private Date lastLogin;
    private String state;
    private String department;
    private int monitoringGroup;
    private String grade;

    public void encodePassword(PasswordEncoder passwordEncoder){
        this.password = passwordEncoder.encode(this.password);
    }
}
