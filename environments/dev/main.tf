locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

## Ensure the hosted zone exists first (so ACM can create DNS validation records)
module "dns_zone" {
  source               = "../../modules/services/route53_zone"
  hosted_zone_name     = var.hosted_zone_name
  prevent_zone_destroy = var.prevent_zone_destroy
}

module "acm" {
  source           = "../../modules/services/acm"
  providers = {
  aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name
  hosted_zone_id   = var.hosted_zone_id != null ? var.hosted_zone_id : module.dns_zone.zone_id
  zone_id          = module.dns_zone.zone_id
  san_enabled      = true
  san_names        = ["*.${var.domain_name}"]
  manage_dns_validation_records = var.manage_dns_validation_records
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# S3 bucket for site content (private)
module "s3" {
  source       = "../../modules/services/s3"
  bucket_name  = "${local.name_prefix}-${replace(var.domain_name, ".", "-")}-site"
  force_destroy = true
  enable_website = false

  # Will be set after CloudFront OAC is known via policy from data/template
}

# CloudFront distribution with OAI
module "cloudfront" {
  source              = "../../modules/services/cloudfront"
  name                = local.name_prefix
  s3_domain_name      = module.s3.bucket_domain_name
  acm_certificate_arn = module.acm.certificate_arn
  use_default_certificate = var.manage_dns_validation_records ? false : true
  aliases             = var.create_www ? [var.domain_name, "www.${var.domain_name}"] : [var.domain_name]
  price_class         = var.price_class
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "s3_oai_policy" {
  statement {
    sid     = "AllowCloudFrontOAIReadOnly"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${module.s3.bucket_arn}/*"
    ]

    principals {
      type        = "CanonicalUser"
      identifiers = [module.cloudfront.oai_s3_canonical_user_id]
    }
  }

  statement {
    sid     = "AllowListBucketForOAI"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      module.s3.bucket_arn
    ]
    principals {
      type        = "CanonicalUser"
      identifiers = [module.cloudfront.oai_s3_canonical_user_id]
    }
  }
}

resource "aws_s3_bucket_policy" "oai_policy" {
  bucket = module.s3.bucket_id
  policy = data.aws_iam_policy_document.s3_oai_policy.json
}

# Route53 records
module "dns" {
  source           = "../../modules/services/route53"
  hosted_zone_name = var.hosted_zone_name
  hosted_zone_id   = var.hosted_zone_id != null ? var.hosted_zone_id : module.dns_zone.zone_id
  domain_name      = var.domain_name
  cf_domain_name   = module.cloudfront.domain_name
  cf_hosted_zone_id = module.cloudfront.hosted_zone_id
  create_apex      = var.manage_dns_validation_records ? var.create_apex : false
  create_www       = var.manage_dns_validation_records ? var.create_www : false
}

# Optional upload of static files
module "uploader" {
  source         = "../../modules/services/s3_objects"
  bucket_id      = module.s3.bucket_id
  site_dir       = var.site_dir
  upload_enabled = var.upload_enabled
  depends_on     = [aws_s3_bucket_policy.oai_policy]
}

# CloudFront invalidation after content upload (native resource)
# CloudFront invalidation after content upload using PowerShell (Windows-safe quoting)
resource "null_resource" "cf_invalidation_after_upload" {
  count = var.upload_enabled ? 1 : 0

  triggers = {
    distribution_id = module.cloudfront.distribution_id
    keys_hash       = md5(join(",", module.uploader.uploaded_keys))
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-NonInteractive", "-Command"]
  command     = "$ErrorActionPreference = 'Stop'; $attempts=0; while ($attempts -lt 3) { try { aws cloudfront create-invalidation --distribution-id ${module.cloudfront.distribution_id} --paths '/*'; break } catch { $attempts++; if ($attempts -ge 3) { throw } Start-Sleep -Seconds 10 } }"
  }

  depends_on = [module.uploader]
}

output "website_url" {
  value = var.create_www ? "https://${var.domain_name} (and https://www.${var.domain_name})" : "https://${var.domain_name}"
}
