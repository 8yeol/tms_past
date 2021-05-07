package com.example.tms.config;
import com.example.tms.entity.RankManagement;
import com.example.tms.repository.RankManagementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;



import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    RankManagementRepository rank_managementRepository;

    @Override
    protected void configure(HttpSecurity http) throws Exception {

/*        http.authorizeRequests().antMatchers("/memberJoin").anonymous()
                .antMatchers("/").access("@authChecker.check(authentication , 'dashboard')")
                .antMatchers("/alarm").access("@authChecker.check(authentication , 'alarm')")
                .antMatchers("/monitoring","/sensor").access("@authChecker.check(authentication , 'monitoring')")
                .antMatchers("/dataInquiry","/dataStatistics").access("@authChecker.check(authentication , 'statistics')")
                .antMatchers("/alarmManagement","/stationManagement","/sensorManagement","/emissionsManagement","/setting").access("@authChecker.check(authentication , 'setting')");

        http.formLogin().loginPage("/login").permitAll();
        http.logout().logoutSuccessUrl("/login");
        http.csrf().disable(); *//*Spring Security에서는 @EnableWebSecurity 지정 시, 자동으로 CSRF 보호 기능이 활성화 *//*
        http.httpBasic();
        http.exceptionHandling().accessDeniedPage("/accessDenied");*/

        http.authorizeRequests().anyRequest().anonymous();
        http.csrf().disable();
        http.httpBasic();

    }
}


