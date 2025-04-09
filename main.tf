terraform {

  cloud {
    organization = "my_test_vesp_org"
    workspaces {
      name = "WroCup2025"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

//tworzenie bucketu pod stronę
resource "aws_s3_bucket" "mytestbucket" {
  bucket = "wroclawcup2025"
}

resource "aws_s3_bucket_website_configuration" "mytestbucket_website" {
  bucket = aws_s3_bucket.mytestbucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.mytestbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.mytestbucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { "Sid" : "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.mytestbucket.arn}/*"
        ]
      }
    ]
    }
  )
}