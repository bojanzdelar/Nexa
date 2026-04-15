#!/usr/bin/env bash

set -euo pipefail

echo "Provision concurrency for frontend SSR"

read -rp "Lambda function name [nexa-frontend-ssr]: " FUNCTION_NAME
FUNCTION_NAME=${FUNCTION_NAME:-nexa-frontend-ssr}

read -rp "Lambda alias [live]: " ALIAS_NAME
ALIAS_NAME=${ALIAS_NAME:-live}

read -rp "Provisioned concurrency [2]: " PC
PC=${PC:-2}

read -rp "Warmup URL [https://nexa.zdelar.com]: " WARMUP_URL
WARMUP_URL=${WARMUP_URL:-https://nexa.zdelar.com}

echo
echo "Fetching current version from alias '$ALIAS_NAME'..."

VERSION=$(aws lambda get-alias \
  --function-name "$FUNCTION_NAME" \
  --name "$ALIAS_NAME" \
  --query 'FunctionVersion' \
  --output text)

echo "Current version: $VERSION"

echo
echo "Enabling provisioned concurrency ($PC)..."

aws lambda put-provisioned-concurrency-config \
  --function-name "$FUNCTION_NAME" \
  --qualifier "$VERSION" \
  --provisioned-concurrent-executions "$PC" \
  > /dev/null

echo "Waiting for provisioned concurrency to be ready..."

while true; do
  STATUS=$(aws lambda get-provisioned-concurrency-config \
    --function-name "$FUNCTION_NAME" \
    --qualifier "$VERSION" \
    --query 'Status' \
    --output text)

  echo "Status: $STATUS"

  if [ "$STATUS" = "READY" ]; then
    break
  elif [ "$STATUS" = "FAILED" ]; then
    echo "Provisioned concurrency failed"
    exit 1
  fi

  sleep 5
done

echo "Warming up application..."

curl -s "$WARMUP_URL" > /dev/null

echo
echo "Done."
