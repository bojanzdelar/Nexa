package com.nexa.user.mapper;

import com.nexa.user.dto.WatchlistEntryDto;
import com.nexa.user.model.UserItem;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {

  @Mapping(target = "id", expression = "java(extractId(item.getSk()))")
  @Mapping(target = "type", expression = "java(extractType(item.getSk()))")
  WatchlistEntryDto toWatchlistEntryDto(UserItem item);

  default Long extractId(String sk) {
    return Long.valueOf(sk.split("#")[2]);
  }

  default String extractType(String sk) {
    return sk.split("#")[1].toLowerCase();
  }
}
