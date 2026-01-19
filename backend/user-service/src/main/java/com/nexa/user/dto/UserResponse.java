package com.nexa.user.dto;

import java.util.UUID;

public record UserResponse(UUID id, String name, String email) {}
