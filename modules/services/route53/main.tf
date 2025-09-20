terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
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
  zone_name = var.hosted_zone_name
}

# Apex A/AAAA alias to CloudFront
resource "aws_route53_record" "apex_a" {
  count   = var.create_apex ? 1 : 0
  zone_id = local.zone_id
  name    = var.zone_root_on_apex ? local.zone_name : var.domain_name
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  count   = var.create_apex ? 1 : 0
  zone_id = local.zone_id
  name    = var.zone_root_on_apex ? local.zone_name : var.domain_name
  type    = "AAAA"
  allow_overwrite = true

  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_hosted_zone_id
    evaluate_target_health = false
  }
}

# Optional www CNAME/alias
resource "aws_route53_record" "www_a" {
  count   = var.create_www ? 1 : 0
  zone_id = local.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  allow_overwrite = true
  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  count   = var.create_www ? 1 : 0
  zone_id = local.zone_id
  name    = "www.${var.domain_name}"
  type    = "AAAA"
  allow_overwrite = true
  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_hosted_zone_id
    evaluate_target_health = false
  }
}
