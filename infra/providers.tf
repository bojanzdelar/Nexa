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

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      project    = "nexa"
      env        = var.environment
      managed_by = "terraform"
    }
  }
}

