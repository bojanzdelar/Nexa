package com.nexa.user.mapper;

import com.nexa.user.dto.UserResponse;
import com.nexa.user.model.UserEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {

  UserResponse toResponse(UserEntity userEntity);
}
