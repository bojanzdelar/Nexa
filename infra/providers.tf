provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project    = "nexa"
      env        = var.environment
      managed_by = "terraform"
    }
  }
}
