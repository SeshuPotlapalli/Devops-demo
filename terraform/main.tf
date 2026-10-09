terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  description = "Globally unique bucket name, e.g. devops-demo-seshu-2026"
  type        = string
}

variable "github_repo" {
  description = "owner/repo that is allowed to deploy, e.g. seshu/devops-demo"
  type        = string
}

# ---------- S3 static website ----------
resource "aws_s3_bucket" "site" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Project = "devops-demo"
  }
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket     = aws_s3_bucket.site.id
  depends_on = [aws_s3_bucket_public_access_block.site]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })
}

# ---------- GitHub Actions OIDC (no stored AWS keys) ----------
# If your account already has this OIDC provider, delete this block and use a data source instead.
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_deploy" {
  name = "github-actions-demo-deploy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = { "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" }
        StringLike   = { "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*" }
      }
    }]
  })
}

resource "aws_iam_role_policy" "deploy_to_bucket" {
  role = aws_iam_role.github_deploy.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:ListBucket", "s3:PutObject", "s3:DeleteObject"]
      Resource = [aws_s3_bucket.site.arn, "${aws_s3_bucket.site.arn}/*"]
    }]
  })
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

output "github_role_arn" {
  value = aws_iam_role.github_deploy.arn
}
