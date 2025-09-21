terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Creates a hosted zone with safe destroy protection by default
resource "aws_route53_zone" "this" {
  name          = var.hosted_zone_name
  force_destroy = true

 
}
