package com.example.tms.service;

import com.example.tms.config.Token;
import com.example.tms.repository.TokenRepository;
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class TokenService implements PersistentTokenRepository {

    final
    TokenRepository repository;

    public TokenService(TokenRepository repository) {
        this.repository = repository;
    }

    @Override
    public void createNewToken(PersistentRememberMeToken token) {
        repository.save(new Token(null,
                token.getUsername(),
                token.getSeries(),
                token.getTokenValue(),
                token.getDate()));
    }

    @Override
    public void updateToken(String series, String value, Date lastUsed) {
        Token token = repository.findBySeries(series);
        repository.save(new Token(token.getId(), token.getUsername(), series, value, lastUsed));
    }

    @Override
    public PersistentRememberMeToken getTokenForSeries(String seriesId) {
        return repository.findBySeries(seriesId);
    }

    @Override
    public void removeUserTokens(String username) {
        Token token = repository.findByUsername(username);
        if (token != null) {
            repository.delete(token);
        }
    }
}