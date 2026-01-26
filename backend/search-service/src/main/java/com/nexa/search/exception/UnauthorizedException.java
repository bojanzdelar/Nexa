package com.nexa.search.exception;

import org.springframework.http.HttpStatus;

public class UnauthorizedException extends ApiException {
  public UnauthorizedException(String message) {
    super(HttpStatus.UNAUTHORIZED, message);
  }
}
