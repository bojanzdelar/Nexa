#!/usr/bin/env bash

set -euo pipefail

echo "Deprovision concurrency for frontend SSR"

read -rp "Lambda function name [nexa-frontend-ssr]: " FUNCTION_NAME
FUNCTION_NAME=${FUNCTION_NAME:-nexa-frontend-ssr}

read -rp "Lambda alias [live]: " ALIAS_NAME
ALIAS_NAME=${ALIAS_NAME:-live}

echo
echo "Fetching current version from alias '$ALIAS_NAME'..."

VERSION=$(aws lambda get-alias \
  --function-name "$FUNCTION_NAME" \
  --name "$ALIAS_NAME" \
  --query 'FunctionVersion' \
  --output text)

echo "Current version: $VERSION"

echo
echo "Removing provisioned concurrency..."

aws lambda delete-provisioned-concurrency-config \
  --function-name "$FUNCTION_NAME" \
  --qualifier "$VERSION" \
  > /dev/null || true

echo
echo "Done."
