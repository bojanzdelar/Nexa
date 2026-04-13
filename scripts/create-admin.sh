#!/usr/bin/env bash

set -euo pipefail

echo "Create Cognito Admin User"

read -rp "User Pool ID: " USER_POOL_ID
read -rp "Admin email: " ADMIN_EMAIL
read -rsp "Admin password: " ADMIN_PASSWORD
echo

GROUP_NAME="ADMIN"

echo "Creating user..."
aws cognito-idp admin-create-user \
  --user-pool-id "$USER_POOL_ID" \
  --username "$ADMIN_EMAIL" \
  --user-attributes \
    Name=email,Value="$ADMIN_EMAIL" \
    Name=email_verified,Value=true \
  --message-action SUPPRESS \
  > /dev/null

echo "Setting password..."
aws cognito-idp admin-set-user-password \
  --user-pool-id "$USER_POOL_ID" \
  --username "$ADMIN_EMAIL" \
  --password "$ADMIN_PASSWORD" \
  --permanent \
  > /dev/null

echo "Adding to ADMIN group..."
aws cognito-idp admin-add-user-to-group \
  --user-pool-id "$USER_POOL_ID" \
  --username "$ADMIN_EMAIL" \
  --group-name "$GROUP_NAME" \
  > /dev/null

echo "Done."