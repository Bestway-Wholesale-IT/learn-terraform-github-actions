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

module "ecr_userapi_dev" {
  source = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = "userapi-dev"
  repository_image_tag_mutability = "MUTABLE"

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

module "ecr_routing-fe-dev" {
  source = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = "routing-fe-dev"
  repository_image_tag_mutability = "MUTABLE"

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

output "repository_routing-fe-dev_arn" {
  description = "Full ARN of the repository"
  value       = module.ecr_routing-fe-dev.repository_arn
}

output "repository_userapi-dev_arn" {
  description = "Full ARN of the repository"
  value       = module.ecr_userapi_dev.repository_arn
}

output "repository_routing-fe-dev_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr_routing-fe-dev.repository_registry_id
}

output "repository_userapi-dev_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr_userapi_dev.repository_registry_id
}

output "repository_routing-fe-dev_url" {
  description = "The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`)"
  value       = module.ecr_routing-fe-dev.repository_url
}

output "repository_userapi-dev_url" {
  description = "The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`)"
  value       = module.ecr_userapi_dev.repository_url
}
