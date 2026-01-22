package com.nexa.catalog.exception;

import com.nexa.catalog.dto.ApiError;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class RestExceptionHandler {

  @ExceptionHandler(ApiException.class)
  public ResponseEntity<ApiError> handleApi(ApiException exception) {
    int status = exception.getStatus().value();

    return ResponseEntity.status(status)
        .body(new ApiError(exception.getMessage(), status, Instant.now(), null));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException exception) {
    Map<String, String> errors = new HashMap<>();
    for (FieldError fieldError : exception.getBindingResult().getFieldErrors()) {
      errors.put(fieldError.getField(), fieldError.getDefaultMessage());
    }

    return ResponseEntity.badRequest()
        .body(
            new ApiError(
                "Validation failed", HttpStatus.BAD_REQUEST.value(), Instant.now(), errors));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiError> handleUnknown(Exception exception) {
    return ResponseEntity.status(500)
        .body(
            new ApiError(
                "Internal server error",
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                Instant.now(),
                null));
  }
}
