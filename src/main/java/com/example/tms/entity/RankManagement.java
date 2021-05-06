package com.example.tms.entity;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "rank_management")
public class RankManagement {

    @Id
    private ObjectId _id;
    private String name;
    private boolean dashboard;
    private boolean alarm;
    private boolean monitoring;
    private boolean statistics;
    private boolean setting;

    public ObjectId get_id() {
        return _id;
    }

    public void set_id(ObjectId _id) {
        this._id = _id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isDashboard() {
        return dashboard;
    }

    public void setDashboard(boolean dashboard) {
        this.dashboard = dashboard;
    }

    public boolean isAlarm() {
        return alarm;
    }

    public void setAlarm(boolean alarm) {
        this.alarm = alarm;
    }

    public boolean isMonitoring() {
        return monitoring;
    }

    public void setMonitoring(boolean monitoring) {
        this.monitoring = monitoring;
    }

    public boolean isStatistics() {
        return statistics;
    }

    public void setStatistics(boolean statistics) {
        this.statistics = statistics;
    }

    public boolean isSetting() {
        return setting;
    }

    public void setSetting(boolean setting) {
        this.setting = setting;
    }

    @Override
    public String toString() {
        return "rank_management{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", dashboard=" + dashboard +
                ", alarm=" + alarm +
                ", monitoring=" + monitoring +
                ", statistics=" + statistics +
                ", setting=" + setting +
                '}';
    }
}
