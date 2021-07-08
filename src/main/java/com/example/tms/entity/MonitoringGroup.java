package com.example.tms.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "monitoring_group")
@NoArgsConstructor
@AllArgsConstructor
public class MonitoringGroup {
    @Id
    private ObjectId _id;
    private String groupName;
    private List groupMember;
    private String monitoring;
    private int groupNum;

}
