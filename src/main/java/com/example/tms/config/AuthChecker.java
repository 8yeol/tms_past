package com.example.tms.config;

import com.example.tms.entity.Member;
import com.example.tms.entity.RankManagement;
import com.example.tms.repository.MemberRepository;
import com.example.tms.repository.RankManagementRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class AuthChecker {

    private final RankManagementRepository rankManagementRepository;
    private final MemberRepository memberRepository;

    public AuthChecker(RankManagementRepository rankManagementRepository, MemberRepository memberRepository) {
        this.rankManagementRepository = rankManagementRepository;
        this.memberRepository = memberRepository;
    }

    /**
     * URL 권한 검사시에 사용되는 Spring Component
     * @param authentication 인증된사용자의 정보객체
     * @param url 권한체크할 url의 String 변수
     * @return
     */
    public boolean check(Authentication authentication,String url){
        Object principalObj = authentication.getPrincipal();
        //로그인 체크
        if(principalObj.equals("anonymousUser")){ return false; }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Member member = memberRepository.findById(userDetails.getUsername());
        RankManagement rankManagement;

        // 5: 거절 - 4: 가입대기 - 3: 일반 - 2: 관리자 - 1: 최고관리자
        if(member.getState().equals("3")){
            rankManagement = rankManagementRepository.findByName("normal");
        } else if (member.getState().equals("2")){
            rankManagement = rankManagementRepository.findByName("admin");
        } else if (member.getState().equals("1")) {
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
