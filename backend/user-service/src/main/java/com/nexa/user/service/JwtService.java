package com.nexa.user.service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

  private final Algorithm algorithm;
  private final long accessTokenMinutes;

  public JwtService(
      @Value("${app.jwt.secret}") String secret,
      @Value("${app.jwt.accessTokenMinutes}") long accessTokenMinutes) {
    this.algorithm = Algorithm.HMAC256(secret);
    this.accessTokenMinutes = accessTokenMinutes;
  }

  public String createAccessToken(UUID userId, String email) {
    Instant now = Instant.now();
    return JWT.create()
        .withSubject(userId.toString())
        .withClaim("email", email)
        .withIssuedAt(now)
        .withExpiresAt(now.plus(accessTokenMinutes, ChronoUnit.MINUTES))
        .sign(algorithm);
  }

  public UUID verifyAndGetUserId(String token) {
    String subject = JWT.require(algorithm).build().verify(token).getSubject();
    return UUID.fromString(subject);
  }
}
