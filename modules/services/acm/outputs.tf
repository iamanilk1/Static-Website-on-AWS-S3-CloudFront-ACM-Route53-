output "certificate_arn" {
  description = "ACM certificate ARN (validated ARN when manage_dns_validation_records=true)"
  value       = var.manage_dns_validation_records ? aws_acm_certificate_validation.this[0].certificate_arn : aws_acm_certificate.this.arn
}

output "validated" {
  description = "Whether the module attempted validation via Route53 DNS records"
  value       = var.manage_dns_validation_records
}

output "validation_records" {
  description = "DNS validation records required by ACM (name, type, value)"
  value = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}
