locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "acm" {
  source           = "../../modules/services/acm"
  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name
  san_enabled      = var.create_www
  san_names        = var.create_www ? ["www.${var.domain_name}"] : []
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
  domain_name      = var.domain_name
  cf_domain_name   = module.cloudfront.domain_name
  cf_hosted_zone_id = module.cloudfront.hosted_zone_id
  create_www       = var.create_www
}

# Optional upload of static files
module "uploader" {
  source         = "../../modules/services/s3_objects"
  bucket_id      = module.s3.bucket_id
  site_dir       = var.site_dir
  upload_enabled = var.upload_enabled
  depends_on     = [aws_s3_bucket_policy.oai_policy]
}

output "cloudfront_domain" {
  value = module.cloudfront.domain_name
}

output "website_url" {
  value = var.create_www ? "https://${var.domain_name} (and https://www.${var.domain_name})" : "https://${var.domain_name}"
}
