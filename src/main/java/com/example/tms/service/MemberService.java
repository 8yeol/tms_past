package com.example.tms.service;

import com.example.tms.entity.Log;
import com.example.tms.entity.Member;
import com.example.tms.repository.LogRepository;
import com.example.tms.repository.MemberRepository;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class MemberService implements UserDetailsService {

    final MemberRepository memberRepository;
    final LogRepository logRepository;
    final PasswordEncoder passwordEncoder;

    public MemberService(MemberRepository memberRepository, LogRepository logRepository, PasswordEncoder passwordEncoder) {
        this.memberRepository = memberRepository;
        this.logRepository = logRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Spring Security 를 통한 로그인
     * @param username 입력한 유저의 ID
     * @return user 타입의 객체를 반환
     * @throws UsernameNotFoundException 예외처리
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Member member = memberRepository.findById(username);
        if (member == null) {
            throw new UsernameNotFoundException(username);
        }
        return User.builder()
                .username(member.getId())
                .password(member.getPassword())
                .roles(member.getState())
                .build();
    }

    /**
     * 유저의 계정정보를 데이터베이스에 저장
     * @param member 멤버객체
     * @param state 권한 값 변수
     * @return 저장 결과 리턴
     */
    public Member memberSave(Member member, String state) {
        member.encodePassword(passwordEncoder);
        member.setState(state);
        return memberRepository.save(member);
    }

    /**
     * [마이페이지] - 회원정보수정
     * @param member 입력받은 변경된 멤버객체
     */
    public void updateMember(Member member) {
        Member updateMember = memberRepository.findById(member.getId());
        updateMember.setName(member.getName());
        if (member.getPassword() != ""){
            updateMember.setPassword(member.getPassword());
            updateMember.encodePassword(passwordEncoder);
        }
        updateMember.setEmail(member.getEmail());
        updateMember.setTel(member.getTel());
        updateMember.setDepartment(member.getDepartment());
        updateMember.setMonitoringGroup(member.getMonitoringGroup());
        updateMember.setGrade(member.getGrade());
        memberRepository.save(updateMember);
    }

    /**
     * 회원정보수정 log 저장
     * @param member log 대상이 되는 멤버객체
     */
    public void updateLog(Member member){
        Date date = new Date();
        Log pwdLog = new Log();
        Log infoLog = new Log();
        if(member.getPassword() != ""){
            pwdLog.setId(member.getId());
            pwdLog.setType("회원");
            pwdLog.setContent("비밀번호 수정");
            pwdLog.setDate(date);
            logRepository.save(pwdLog);
        }
        infoLog.setId(member.getId());
        infoLog.setType("회원");
        infoLog.setContent("정보수정");
        infoLog.setDate(date);
        logRepository.save(infoLog);
    }

    /**
     * 유저 탈퇴, 제명 처리
     * @param id 탈퇴, 제명할 유저의 아이디
     */
    public void deleteById(String id) {
        memberRepository.deleteById(id);
    }
}
