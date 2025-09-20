output "s3_bucket" {
  value = module.s3.bucket_id
}

output "cloudfront_domain" {
  value = module.cloudfront.domain_name
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}
