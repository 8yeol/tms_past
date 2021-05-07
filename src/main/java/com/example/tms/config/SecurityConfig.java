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
/*        List<RankManagement> rm = rank_managementRepository.findAll();
        String dashboard = "" , alarm = "" , monitoring = "" , Statistics = "" , Setting  = "";
        for(int i = 0;i < rm.size();i++){
            int rNum = i+2;
            if(rm.get(i).isDashboard()) //권한값이 True 이면 추가
                dashboard += ", ROLE_"+rNum;
            if(rm.get(i).isAlarm())
                alarm += ", ROLE_"+rNum;
            if(rm.get(i).isAlarm())
                monitoring += ", ROLE_"+rNum;
            if(rm.get(i).isStatistics())
                Statistics += ", ROLE_"+rNum;
            if(rm.get(i).isSetting())
                Setting += ", ROLE_"+rNum;
        }
        http.authorizeRequests().antMatchers("/").hasAnyAuthority(dashboard)
                .antMatchers("/memberJoin").anonymous()
                .antMatchers("/alarm").hasAnyAuthority(alarm)
                .antMatchers("/monitoring","/sensor").hasAnyAuthority(monitoring)
                .antMatchers("/dataInquiry","/dataStatistics").hasAnyAuthority(Statistics)
                .antMatchers("/alarmManagement","/stationManagement","/sensorManagement","/emissionsManagement","/setting").hasAnyAuthority(Setting);


        http.formLogin().loginPage("/login").permitAll();
        http.logout().logoutSuccessUrl("/login");
        http.csrf().disable();*//* Spring Security에서는 @EnableWebSecurity 지정 시, 자동으로 CSRF 보호 기능이 활성화 *//*
        http.httpBasic();
        http.exceptionHandling().accessDeniedPage("/accessDenied");*/

        http.authorizeRequests().anyRequest().anonymous();

    }
}


