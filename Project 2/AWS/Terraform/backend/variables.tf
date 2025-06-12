variable "region" {
  default = "eu-north-1"
}

variable "bucket_name" {
  default = "farah-terraform-state-bucket"
}

variable "bucket_tags" {
  type = map(string)
  default = {
    Name        = "Terraform State Bucket"
    Environment = "dev"
  }
}

variable "lock_table_name" {
  default = "terraform-lock-table"
}

variable "lock_table_hash_key" {
  default = "LockID"
}

variable "attribute_name" {
  default = "LockID"
}

variable "attribute_type" {
  default = "S"
}

variable "dynamodb_table_billing_mode" {
  default = "PAY_PER_REQUEST"
}

variable "dynamodb_table_tags" {
  type = map(string)
  default = {
    Name        = "Terraform Lock Table"
    Environment = "dev"
  }
}