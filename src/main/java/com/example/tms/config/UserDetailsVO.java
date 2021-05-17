package com.example.tms.config;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class UserDetailsVO implements UserDetails {

    // 안만들어도 상관없지만 Warning이 발생함
    private static final long serialVersionUID = 1L;

    private String username; // ID
    private String password; // PW
    private List<GrantedAuthority> authorities;

    // setter
    public void setUsername(String username) {
        this.username = username;
    }
    // setter
    public void setPassword(String password) {
        this.password = password;
    }
    // setter
    public void setAuthorities(List<String> authList) {
        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
        for (int i = 0; i < authList.size(); i++) {
            authorities.add(new SimpleGrantedAuthority(authList.get(i)));
        }
        this.authorities = authorities;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
