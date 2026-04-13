#!/usr/bin/env bash

set -euo pipefail

echo "Reindex Search"

read -rp "Cognito region [eu-central-1]: " COGNITO_REGION
COGNITO_REGION=${COGNITO_REGION:-eu-central-1}

read -rp "Cognito client ID: " COGNITO_CLIENT_ID
read -rp "Username: " USERNAME
read -rsp "Password: " PASSWORD
echo

read -rp "API domain [nexa.zdelar.com]: " API_DOMAIN
API_DOMAIN=${API_DOMAIN:-nexa.zdelar.com}

API_URL="https://api.${API_DOMAIN}/search/reindex"

echo "Getting access token..."

TOKEN=$(aws cognito-idp initiate-auth \
  --region "$COGNITO_REGION" \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id "$COGNITO_CLIENT_ID" \
  --auth-parameters USERNAME="$USERNAME",PASSWORD="$PASSWORD" \
  --query 'AuthenticationResult.AccessToken' \
  --output text)

echo "Calling reindex endpoint..."

curl -sS -X POST "$API_URL" \
  -H "Authorization: Bearer $TOKEN" \
  > /dev/null

echo "Done."