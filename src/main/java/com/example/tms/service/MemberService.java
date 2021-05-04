package com.example.tms.service;

import com.example.tms.entity.Member;
import com.example.tms.repository.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class MemberService implements UserDetailsService {

    @Autowired
    MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Member member = memberRepository.findById(username);
        if(member == null){
            throw new UsernameNotFoundException(username);
        }
        return User.builder()
                .username(member.getId())
                .password(member.getPassword())
                .roles(member.getState())
                .build();
    }
}
