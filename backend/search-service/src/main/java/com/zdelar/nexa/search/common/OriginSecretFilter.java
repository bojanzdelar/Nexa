package com.zdelar.nexa.search.common;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class OriginSecretFilter extends OncePerRequestFilter {

  @Value("${origin.secret:}")
  private String expectedSecret;

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws ServletException, IOException {

    boolean disabled = expectedSecret.isBlank();
    boolean isActuator = request.getRequestURI().startsWith("/actuator");
    boolean isPreflight = "OPTIONS".equalsIgnoreCase(request.getMethod());

    if (disabled || isActuator || isPreflight) {
      filterChain.doFilter(request, response);
      return;
    }

    String header = request.getHeader("X-Origin-Secret");

    if (!expectedSecret.equals(header)) {
      response.setStatus(HttpServletResponse.SC_FORBIDDEN);
      return;
    }

    filterChain.doFilter(request, response);
  }
}
