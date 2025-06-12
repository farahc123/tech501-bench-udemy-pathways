provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_tags["Name"]
    Environment = var.bucket_tags["Environment"]
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.lock_table_name
  billing_mode = var.dynamodb_table_billing_mode
  hash_key     = var.lock_table_hash_key

  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  tags = {
    Name        = var.dynamodb_table_tags["Name"]
    Environment = var.dynamodb_table_tags["Environment"]
  }
}
