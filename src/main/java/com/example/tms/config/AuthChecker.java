package com.example.tms.config;

import com.example.tms.entity.Member;
import com.example.tms.entity.RankManagement;
import com.example.tms.repository.MemberRepository;
import com.example.tms.repository.RankManagementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class AuthChecker {

    @Autowired
    private RankManagementRepository rankManagementRepository;

    @Autowired
    private MemberRepository memberRepository;

    public boolean check(Authentication authentication,String url){

        Object principalObj = authentication.getPrincipal();
        //로그인 체크
        if(principalObj.equals("anonymousUser")){ return false; }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Member member = memberRepository.findById(userDetails.getUsername());
        RankManagement rankManagement;

        //등급 체크
        if(member.getState().equals("2")){
            rankManagement = rankManagementRepository.findByName("normal");
        } else if (member.getState().equals("3")){
            rankManagement = rankManagementRepository.findByName("admin");
        } else if (member.getState().equals("4")) {
            rankManagement = rankManagementRepository.findByName("root");
        } else {
            return false;
        }

        //권한 체크
        if(url.equals("dashboard")){
            return rankManagement.isDashboard();
        } else if (url.equals("alarm")){
            return rankManagement.isAlarm();
        } else if (url.equals("monitoring")){
            return rankManagement.isMonitoring();
        } else if (url.equals("statistics")){
            return rankManagement.isStatistics();
        } else if(url.equals("setting")){
            return rankManagement.isSetting();
        } else {
            return false;
        }
    }
}
