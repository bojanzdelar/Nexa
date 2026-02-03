resource "aws_cognito_user_pool" "this" {
  name                = "nexa-user-pool"
  deletion_protection = "ACTIVE"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_numbers                  = false
    require_uppercase                = false
    require_symbols                  = false
    temporary_password_validity_days = 7
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account  = "DEVELOPER"
    from_email_address     = "Nexa <nexa@zdelar.com>"
    reply_to_email_address = "nexa@zdelar.com"
    source_arn             = "arn:aws:ses:eu-central-1:657845675364:identity/nexa@zdelar.com" # TODO: extract this
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
    invite_message_template {
      email_subject = "Your Nexa temporary password"
      sms_message   = "Your Nexa username is {username} and temporary password is {####}."
      email_message = file("${path.module}/templates/invitation_email.html")
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your Nexa verification code"
    sms_message          = "Your Nexa verification code is {####}."
    email_message        = file("${path.module}/templates/verification_email.html")
  }

  sms_authentication_message = "Your Nexa authentication code is {####}."

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }

  schema {
    name                = "given_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
}

resource "aws_cognito_user_pool_client" "app" {
  name         = "nexa-web"
  user_pool_id = aws_cognito_user_pool.this.id

  supported_identity_providers = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
  ]
}
