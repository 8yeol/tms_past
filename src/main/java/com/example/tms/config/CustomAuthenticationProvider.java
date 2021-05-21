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

    /**
     * 유저의 로그인과정중 거치게되는 인증절차
     * @param authentication 인증정보객체
     * @return 인증이끝난 정보객체 리턴
     * @throws AuthenticationException 예외처리
     */
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String userId = authentication.getName();
        String userPw = (String) authentication.getCredentials();
        UserDetailsVO userDetails = (UserDetailsVO) userDetailsServcie
                .loadUserByUsername(userId);
        if (userDetails == null || !userId.equals(userDetails.getUsername())
                || !passwordEncoder.matches(userPw, userDetails.getPassword())) {
            throw new BadCredentialsException(userId);
        } else if (!userDetails.isAccountNonLocked()) {
            throw new LockedException(userId);
        } else if (!userDetails.isEnabled()) {
            throw new DisabledException(userId);
        } else if (!userDetails.isAccountNonExpired()) {
            throw new AccountExpiredException(userId);
        } else if (!userDetails.isCredentialsNonExpired()) {
            throw new CredentialsExpiredException(userId);
        }
        userDetails.setPassword(null);
        Authentication newAuth = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());

        return newAuth;
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}
