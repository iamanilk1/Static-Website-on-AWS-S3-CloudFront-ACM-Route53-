terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Optional bulk upload of files in a local directory to S3.
# Uses fileset + aws_s3_object resources.

locals {
  files = var.upload_enabled ? fileset(var.site_dir, "**") : []
}

resource "aws_s3_object" "this" {
  for_each = { for f in local.files : f => f if !startswith(f, ".terraform/") }

  bucket       = var.bucket_id
  key          = each.key
  source       = "${var.site_dir}/${each.key}"
  content_type = lookup(var.content_types, regex("\\.[^.]+$", each.key), null)
  etag         = filemd5("${var.site_dir}/${each.key}")

  # Cache-Control can be tuned via var.cache_control
  cache_control = var.cache_control
}
