terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Create Origin Access Identity (OAI) to access S3
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for ${var.name}"
}

locals {
  default_cache_policy = var.cache_policy_id == null ? data.aws_cloudfront_cache_policy.caching_optimized.id : var.cache_policy_id
  default_origin_id    = "s3-origin"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "user_agent_referer" {
  name = "Managed-AllViewerExceptHostHeader"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comment
  default_root_object = var.default_root_object

  aliases = var.aliases

  origin {
    domain_name = var.s3_domain_name
    origin_id   = local.default_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.default_origin_id

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id            = local.default_cache_policy
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.user_agent_referer.id
    compress                   = true
    response_headers_policy_id = var.response_headers_policy_id
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.minimum_protocol_version
    cloudfront_default_certificate = false
  }

  tags = var.tags
}
