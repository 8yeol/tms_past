package com.example.tms.service;


import com.example.tms.entity.RankManagement;
import com.example.tms.repository.RankManagementRepository;
import org.springframework.stereotype.Service;

@Service
public class RankManagementService {

    final RankManagementRepository rankManagementRepository;

    public RankManagementService(RankManagementRepository rankManagementRepository) {
        this.rankManagementRepository = rankManagementRepository;
    }

    /**
     * 데이터베이스에 저장될 기본권한값
     */
    public void defaultRankSetting () {
        RankManagement denie = new RankManagement();
        denie.setName("denie");
        denie.setDashboard(false);
        denie.setAlarm(false);
        denie.setMonitoring(false);
        denie.setStatistics(false);
        denie.setSetting(false);
        rankManagementRepository.save(denie);


        RankManagement user = new RankManagement();
        user.setName("normal");
        user.setDashboard(true);
        user.setAlarm(false);
        user.setMonitoring(false);
        user.setStatistics(false);
        user.setSetting(false);
        rankManagementRepository.save(user);

        RankManagement admin = new RankManagement();
        admin.setName("admin");
        admin.setDashboard(false);
        admin.setAlarm(false);
        admin.setMonitoring(false);
        admin.setStatistics(false);
        admin.setSetting(false);
        rankManagementRepository.save(admin);

        RankManagement root = new RankManagement();
        root.setName("root");
        root.setDashboard(true);
        root.setAlarm(true);
        root.setMonitoring(true);
        root.setStatistics(true);
        root.setSetting(true);
        rankManagementRepository.save(root);
    }
}
