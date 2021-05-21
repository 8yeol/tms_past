package com.example.tms.config;
import com.example.tms.repository.RankManagementRepository;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    final RankManagementRepository rank_managementRepository;

    public SecurityConfig(RankManagementRepository rank_managementRepository) {
        this.rank_managementRepository = rank_managementRepository;
    }

    /**
     * 각 페이지 접근시 해당 URL 에 대한 동적 권한 검사
     * @param http 시큐리티 설정 객체
     * @throws Exception 예외처리
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http.authorizeRequests().antMatchers("/memberJoin").anonymous()
                .antMatchers("/myPage").authenticated()
                .antMatchers("/").access("@authChecker.check(authentication , 'dashboard')")
                .antMatchers("/alarm").access("@authChecker.check(authentication , 'alarm')")
                .antMatchers("/monitoring","/sensor").access("@authChecker.check(authentication , 'monitoring')")
                .antMatchers("/dataInquiry","/dataStatistics").access("@authChecker.check(authentication , 'statistics')")
                .antMatchers("/alarmManagement","/stationManagement","/sensorManagement","/emissionsManagement","/setting","/log").access("@authChecker.check(authentication , 'setting')");
        http.formLogin().loginPage("/login").permitAll();
        http.logout().logoutSuccessUrl("/login");
        http.csrf().disable();
        http.httpBasic();
        http.exceptionHandling().accessDeniedPage("/accessDenied");
    }
}


