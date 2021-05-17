package com.example.tms.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;

public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    UserDetailsService userDetailsServcie;

    @Autowired
    PasswordEncoder passwordEncoder;
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        /* 사용자가 입력한 정보 */
        String userId = authentication.getName();
        String userPw = (String) authentication.getCredentials();
        /* DB에서 가져온 정보 (커스터마이징 가능) */
        UserDetailsVO userDetails = (UserDetailsVO) userDetailsServcie
                .loadUserByUsername(userId);
        // DB에 정보가 없는 경우 예외 발생 (아이디/패스워드 잘못됐을 때와 동일한 것이 좋음)
        // ID 및 PW 체크해서 안맞을 경우 (matches를 이용한 암호화 체크)
        if (userDetails == null || !userId.equals(userDetails.getUsername())
                || !passwordEncoder.matches(userPw, userDetails.getPassword())) {
            throw new BadCredentialsException(userId);
            // 계정 정보 맞으면 나머지 부가 메소드 체크 (이부분도 필요한 부분만 커스터마이징)
        } else if (!userDetails.isAccountNonLocked()) {
            throw new LockedException(userId);
            // 비활성화된 계정일 경우
        } else if (!userDetails.isEnabled()) {
            throw new DisabledException(userId);
            // 만료된 계정일 경우
        } else if (!userDetails.isAccountNonExpired()) {
            throw new AccountExpiredException(userId);
            // 비밀번호가 만료된 경우
        } else if (!userDetails.isCredentialsNonExpired()) {
            throw new CredentialsExpiredException(userId);
        }
        // 객체를 계속 사용해야 하므로 다 썼으면 패스워드 정보는 지워줌
        userDetails.setPassword(null);
        /* 최종 리턴 시킬 새로만든 Authentication 객체 */
        Authentication newAuth = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());

        return newAuth;
    }

    @Override
    public boolean supports(Class<?> authentication) {
        // 스프링 Security가 요구하는 UsernamePasswordAuthenticationToken 타입이 맞는지 확인
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}
