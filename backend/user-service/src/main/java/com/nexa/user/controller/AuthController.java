package com.nexa.user.controller;

import com.nexa.user.dto.AuthResponse;
import com.nexa.user.dto.RefreshResponse;
import com.nexa.user.dto.UserLoginRequest;
import com.nexa.user.dto.UserRegisterRequest;
import com.nexa.user.service.AuthService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

  private final AuthService authService;

  @Value("${app.jwt.refreshTokenDays}")
  private long refreshTokenDays;

  @Value("${app.cookie.refreshTokenName}")
  private String refreshCookieName;

  @PostMapping("/register")
  public ResponseEntity<Void> register(@RequestBody @Valid UserRegisterRequest request) {
    authService.register(request);
    return ResponseEntity.status(201).build();
  }

  @PostMapping("/login")
  public ResponseEntity<AuthResponse> login(
      @RequestBody @Valid UserLoginRequest request, HttpServletResponse response) {
    AuthService.AuthResult result = authService.login(request);

    ResponseCookie cookie =
        ResponseCookie.from(refreshCookieName, result.refreshToken())
            .httpOnly(true)
            .secure(false) // set TRUE in prod with HTTPS
            .sameSite("Lax")
            .path("/")
            .maxAge(60 * 60 * 24 * refreshTokenDays)
            .build();

    response.addHeader("Set-Cookie", cookie.toString());
    return ResponseEntity.ok(result.body());
  }

  @PostMapping("/refresh")
  public ResponseEntity<RefreshResponse> refresh(
      @CookieValue(name = "${app.cookie.refreshTokenName}", required = false) String refreshToken) {
    return ResponseEntity.ok(authService.refresh(refreshToken));
  }

  @PostMapping("/logout")
  public ResponseEntity<Void> logout(
      @CookieValue(name = "${app.cookie.refreshTokenName}", required = false) String refreshToken,
      HttpServletResponse response) {
    ResponseCookie cookie =
        ResponseCookie.from(refreshCookieName, "")
            .httpOnly(true)
            .secure(false) // true in prod
            .sameSite("Lax")
            .path("/")
            .maxAge(0)
            .build();

    response.addHeader("Set-Cookie", cookie.toString());

    if (refreshToken != null && !refreshToken.isBlank()) {
      authService.logout(refreshToken);
    }
    return ResponseEntity.noContent().build();
  }
}
