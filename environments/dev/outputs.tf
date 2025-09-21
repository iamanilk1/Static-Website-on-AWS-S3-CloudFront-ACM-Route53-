output "s3_bucket" {
  value = module.s3.bucket_id
}

output "cloudfront_domain" {
  value = module.cloudfront.domain_name
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "route53_zone_id" {
  description = "Hosted zone id used for records"
  value       = module.dns.zone_id
}

output "acm_validation_records" {
  description = "DNS records ACM expects for validation"
  value       = module.acm.validation_records
}
