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

locals {
  # When managing DNS records, resolve the zone id (prefer hosted_zone_id, else provided zone_id). Otherwise, leave null.
  zone_id = var.manage_dns_validation_records ? (
    var.hosted_zone_id != null ? var.hosted_zone_id : var.zone_id
  ) : null
  # Static list of domains to validate (keys known at plan time)
  validation_domains = distinct(concat([var.domain_name], var.san_enabled ? var.san_names : []))

  # Map DVOs by domain (values known at apply, which is fine for resource attributes)
  dvo_by_domain = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => dvo
  }
}

resource "aws_route53_record" "validation" {
  for_each = var.manage_dns_validation_records ? { for d in local.validation_domains : d => d } : {}

  zone_id = local.zone_id
  name    = lookup(local.dvo_by_domain, each.key).resource_record_name
  type    = lookup(local.dvo_by_domain, each.key).resource_record_type
  ttl     = 60
  records = [lookup(local.dvo_by_domain, each.key).resource_record_value]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  count                   = var.manage_dns_validation_records ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}
