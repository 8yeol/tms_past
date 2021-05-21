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

    public Member memberSave(Member member, String state) {
        member.encodePassword(passwordEncoder);
        member.setState(state);
        return memberRepository.save(member);
    }

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
        updateMember.setGrade(member.getGrade());
        memberRepository.save(updateMember);
    }

    public void updateLog(Member member){
        Date date = new Date();
        Log pwdLog = new Log();
        Log infoLog = new Log();
        if(member.getPassword() != ""){
            pwdLog.setId(member.getId());
            pwdLog.setType("회원수정");
            pwdLog.setContent("비밀번호 수정");
            pwdLog.setDate(date);
            logRepository.save(pwdLog);
        }
        infoLog.setId(member.getId());
        infoLog.setType("회원수정");
        infoLog.setContent("정보수정");
        infoLog.setDate(date);
        logRepository.save(infoLog);
    }

    public void deleteById(String id) {
        memberRepository.deleteById(id);
    }
}
