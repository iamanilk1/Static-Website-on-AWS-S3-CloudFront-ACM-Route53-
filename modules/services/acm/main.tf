terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
  configuration_aliases = [aws.us_east_1]
    }
  }
}

# NOTE: This module must be used with provider alias in us-east-1 to work with CloudFront.

resource "aws_acm_certificate" "this" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.san_enabled ? var.san_names : []

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_route53_zone" "this" {
  count = var.create_zone && var.hosted_zone_id == null ? 1 : 0
  name  = var.hosted_zone_name
}

data "aws_route53_zone" "this" {
  count        = var.create_zone || var.hosted_zone_id != null ? 0 : 1
  name         = var.hosted_zone_name
  private_zone = false
}

locals {
  zone_id = var.hosted_zone_id != null ? var.hosted_zone_id : (
    var.create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.this[0].zone_id
  )
  # Group by record name (some SANs share the same validation CNAME), then pick the first to dedupe
  validation_records_grouped = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.resource_record_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }...
  }

  validation_records = {
    for name, items in local.validation_records_grouped : name => items[0]
  }
}

resource "aws_route53_record" "validation" {
  for_each = local.validation_records
  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}
