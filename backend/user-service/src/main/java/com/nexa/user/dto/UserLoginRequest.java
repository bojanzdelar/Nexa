package com.nexa.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UserLoginRequest(
    @Email @NotBlank String email, @Size(min = 4, max = 60) String password) {}
