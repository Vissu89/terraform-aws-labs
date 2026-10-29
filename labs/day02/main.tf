terraform {
  required_version = ">=1.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.6"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "tf-lab"

  default_tags {
    tags = {
      Project   = "terraform-aws-labs"
      Owner     = "viswanath"
      Managedby = "terraform"
      Environment = "dev"
      Environment = "dev"

    }
  }
}

resource "random_pet" "suffix" {
  length = 2
}
resource "aws_s3_bucket" "lab" {
  bucket = "tf-lab-${random_pet.suffix.id}"
}
resource "aws_s3_bucket_versioning" "lab" {
  bucket = aws_s3_bucket.lab.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "lab" {
  bucket                  = aws_s3_bucket.lab.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.lab.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.lab.arn
}