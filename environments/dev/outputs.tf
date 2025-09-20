output "s3_bucket" {
  value = module.s3.bucket_id
}

output "cloudfront_domain" {
  value = module.cloudfront.domain_name
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "route53_name_servers" {
  description = "Name servers for the hosted zone (if Terraform created it)"
  value       = module.dns.name_servers
}

output "acm_validation_records" {
  description = "DNS records ACM expects for validation"
  value       = module.acm.validation_records
}
