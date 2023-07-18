# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
    
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = "userapi-private"

  repository_read_write_access_arns = ["arn:aws:iam::885977531413:user/svc-webdeploy"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}