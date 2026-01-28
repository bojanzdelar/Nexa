package com.nexa.user.repository;

import static com.nexa.user.constants.DynamoKeys.*;

import com.nexa.user.model.UserItem;
import java.time.Instant;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.*;
import software.amazon.awssdk.enhanced.dynamodb.model.QueryConditional;

@Repository
public class UserRepository {

  private final DynamoDbTable<UserItem> table;

  public UserRepository(
      DynamoDbEnhancedClient client, @Value("${aws.dynamodb.users.table-name}") String tableName) {
    this.table = client.table(tableName, TableSchema.fromImmutableClass(UserItem.class));
  }

  public List<UserItem> getWatchlist(String userId) {
    return table
        .query(r -> r.queryConditional(userPrefixQuery(userId, WATCHLIST_PREFIX)))
        .items()
        .stream()
        .toList();
  }

  public void addWatchlist(String userId, String type, String titleId) {
    table.putItem(
        UserItem.builder()
            .pk(userPk(userId))
            .sk(watchlistSk(type, titleId))
            .updatedAt(Instant.now())
            .build());
  }

  public void removeWatchlist(String userId, String type, String titleId) {
    table.deleteItem(
        Key.builder().partitionValue(userPk(userId)).sortValue(watchlistSk(type, titleId)).build());
  }

  private QueryConditional userPrefixQuery(String userId, String prefix) {
    return QueryConditional.sortBeginsWith(
        Key.builder().partitionValue(userPk(userId)).sortValue(prefix).build());
  }
}
