#!/usr/bin/env bash

set -euo pipefail

echo "Terraform Bootstrap"

read -rp "AWS region [eu-central-1]: " AWS_REGION
AWS_REGION=${AWS_REGION:-eu-central-1}

read -rp "TF state bucket prefix [nexa-terraform-state]: " TF_BUCKET_PREFIX
TF_BUCKET_PREFIX=${TF_BUCKET_PREFIX:-nexa-terraform-state}

read -rp "TF lock table name [nexa-terraform-lock]: " TF_LOCK
TF_LOCK=${TF_LOCK:-nexa-terraform-lock}

aws sts get-caller-identity >/dev/null
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

FINAL_BUCKET="${TF_BUCKET_PREFIX}-${ACCOUNT_ID}"

echo "Bootstrapping backend..."
cd ../infra/bootstrap

terraform init -input=false > /dev/null

terraform apply -auto-approve -input=false \
  -var="aws_region=$AWS_REGION" \
  -var="tf_state_bucket_name=$FINAL_BUCKET" \
  -var="tf_lock_table_name=$TF_LOCK"

echo "Initializing main Terraform..."
cd ..

terraform init -reconfigure -input=false > /dev/null \
  -backend-config="bucket=$FINAL_BUCKET" \
  -backend-config="key=infra/terraform.tfstate" \
  -backend-config="region=$AWS_REGION" \
  -backend-config="dynamodb_table=$TF_LOCK"

echo
echo "Terraform initialized successfully."