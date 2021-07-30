package com.example.tms.config;
import com.example.tms.repository.RankManagementRepository;
import com.example.tms.service.MemberService;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    final RankManagementRepository rank_managementRepository;
    final PersistentTokenRepository repository;
    final MemberService memberService;

    public SecurityConfig(RankManagementRepository rank_managementRepository, PersistentTokenRepository repository, MemberService memberService) {
        this.rank_managementRepository = rank_managementRepository;
        this.repository = repository;
        this.memberService = memberService;
    }

    /**
     * 각 페이지 접근시 해당 URL 에 대한 동적 권한 검사
     * @param http 시큐리티 설정 객체
     * @throws Exception 예외처리
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http.headers().cacheControl().disable();

        http.authorizeRequests().antMatchers("/memberJoin").anonymous()
                .antMatchers("/myPage").authenticated()
                .antMatchers("/dashboard").access("@authChecker.check(authentication , 'dashboard')")
                .antMatchers("/alarm").access("@authChecker.check(authentication , 'alarm')")
                .antMatchers("/","/monitoring","/sensor").access("@authChecker.check(authentication , 'monitoring')")
                .antMatchers("/dataInquiry","/dataStatistics").access("@authChecker.check(authentication , 'statistics')")
                .antMatchers("/alarmManagement","/stationManagement","/sensorManagement","/emissionsManagement","/setting","/log").access("@authChecker.check(authentication , 'setting')");
        http.formLogin().loginPage("/login").permitAll();
        http.logout().logoutSuccessUrl("/login");
        http.csrf().disable();
        http.httpBasic();
        http.exceptionHandling().accessDeniedPage("/accessDenied");
        http.exceptionHandling().authenticationEntryPoint(new AuthenticationEntryPoint() {
            @Override
            public void commence(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException e) throws IOException, ServletException {
                httpServletResponse.sendRedirect("/lghausys/logout");
            }
        });

        http.rememberMe()
                .key("jpa")
                .userDetailsService(memberService)
                .tokenRepository(repository)
                .tokenValiditySeconds(60*60*24*30);
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers("/static/public/**");
    }

}


