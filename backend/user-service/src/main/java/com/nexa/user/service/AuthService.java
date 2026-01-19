package com.nexa.user.service;

import com.nexa.user.dto.*;
import com.nexa.user.mapper.UserMapper;
import com.nexa.user.model.RefreshTokenEntity;
import com.nexa.user.model.UserEntity;
import com.nexa.user.repository.RefreshTokenRepository;
import com.nexa.user.repository.UserRepository;
import com.nexa.user.util.HashUtil;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

  private final JwtService jwtService;
  private final UserRepository userRepository;
  private final UserMapper userMapper;
  private final RefreshTokenRepository refreshTokenRepository;
  private final PasswordEncoder encoder;

  @Value("${app.jwt.refreshHashSecret}")
  private String refreshHashSecret;

  @Value("${app.jwt.refreshTokenDays}")
  private long refreshTokenDays;

  public void register(UserRegisterRequest request) {
    if (userRepository.existsByEmail(request.email())) {
      throw new IllegalArgumentException("Email already exists");
    }

    UserEntity user =
        UserEntity.builder()
            .name(request.name())
            .email(request.email().toLowerCase().trim())
            .passwordHash(encoder.encode(request.password()))
            .createdAt(Instant.now())
            .build();

    userRepository.save(user);
  }

  public AuthResult login(UserLoginRequest request) {
    UserEntity user =
        userRepository
            .findByEmail(request.email().toLowerCase().trim())
            .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));

    if (!encoder.matches(request.password(), user.getPasswordHash())) {
      throw new IllegalArgumentException("Invalid credentials");
    }

    String accessToken = jwtService.createAccessToken(user.getId(), user.getEmail());
    String refreshTokenRaw =
        UUID.randomUUID().toString() + UUID.randomUUID(); // random string

    RefreshTokenEntity refreshToken =
        RefreshTokenEntity.builder()
            .userId(user.getId())
            .tokenHash(HashUtil.hmacSha256Hex(refreshTokenRaw, refreshHashSecret))
            .createdAt(Instant.now())
            .expiresAt(Instant.now().plus(refreshTokenDays, ChronoUnit.DAYS))
            .build();

    refreshTokenRepository.save(refreshToken);

    return new AuthResult(
        new AuthResponse(accessToken, userMapper.toResponse(user)), refreshTokenRaw);
  }

  public RefreshResponse refresh(String refreshTokenRaw) {
    if (refreshTokenRaw == null || refreshTokenRaw.isBlank()) {
      throw new IllegalArgumentException("No refresh token");
    }

    String hash = HashUtil.hmacSha256Hex(refreshTokenRaw, refreshHashSecret);

    RefreshTokenEntity refreshToken =
        refreshTokenRepository
            .findByTokenHash(hash)
            .orElseThrow(() -> new IllegalArgumentException("Invalid refresh token"));

    if (refreshToken.getExpiresAt().isBefore(Instant.now())) {
      refreshTokenRepository.delete(refreshToken);
      throw new IllegalArgumentException("Refresh token expired");
    }

    UserEntity user =
        userRepository
            .findById(refreshToken.getUserId())
            .orElseThrow(() -> new IllegalArgumentException("User missing"));

    String access = jwtService.createAccessToken(user.getId(), user.getEmail());
    return new RefreshResponse(access);
  }

  public void logout(String refreshToken) {
    String hash = HashUtil.hmacSha256Hex(refreshToken, refreshHashSecret);
    refreshTokenRepository.deleteByTokenHash(hash);
  }

  public record AuthResult(AuthResponse body, String refreshToken) {}
}
