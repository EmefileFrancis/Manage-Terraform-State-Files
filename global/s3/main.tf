provider "aws" {
  region = "us-east-2"
  profile = "emefile.franklin"
}

#terraform {
#  backend "s3" {
#    bucket = "wajei-terraform-up-and-running-state"
#    key = "global/s3/terraform.tfstate"
#    region = "us-east-2"
#
#    dynamodb_table = "terraform-up-and-running-locks"
#    encrypt = true
#  }
#}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "wajei-terraform-up-and-running-state"

  # Prevent accidental deletion of this bucket
#  lifecycle {
#    prevent_destroy = true
#  }
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Explicitly block all public access to the S3 Bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
