package com.nexa.user.repository;

import static com.nexa.user.constants.DynamoKeys.*;

import com.nexa.user.model.UserItem;
import java.util.List;
import java.util.Optional;
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

  public Optional<UserItem> findByKey(String pk, String sk) {
    return Optional.ofNullable(
        table.getItem(Key.builder().partitionValue(pk).sortValue(sk).build()));
  }

  public List<UserItem> findAllByPkAndSkPrefix(String pk, String skPrefix) {
    var query =
        QueryConditional.sortBeginsWith(
            Key.builder().partitionValue(pk).sortValue(skPrefix).build());

    return table.query(r -> r.queryConditional(query)).items().stream().toList();
  }

  public void put(UserItem item) {
    table.putItem(item);
  }

  public void delete(String pk, String sk) {
    table.deleteItem(Key.builder().partitionValue(pk).sortValue(sk).build());
  }
}
