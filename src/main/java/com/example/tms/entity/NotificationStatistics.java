package com.example.tms.entity;

import lombok.Builder;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "notification_statistics")
public class NotificationStatistics {

    @Id
    private ObjectId _id;
    private String place; //측정소명
    private String from_date;
    private String to_date;
    private int count;

    @Builder
    public NotificationStatistics(String place, String from_date, String to_date, int count) {
        this.place = place;
        this.from_date = from_date;
        this.to_date = to_date;
        this.count = count;
    }

    public ObjectId get_id() {
        return _id;
    }

    public void set_id(ObjectId _id) {
        this._id = _id;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getFrom_date() {
        return from_date;
    }

    public void setFrom_date(String from_date) {
        this.from_date = from_date;
    }

    public String getTo_date() {
        return to_date;
    }

    public void setTo_date(String to_date) {
        this.to_date = to_date;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
