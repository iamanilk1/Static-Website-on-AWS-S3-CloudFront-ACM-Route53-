output "distribution_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "CloudFront distribution ID"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "CloudFront distribution ARN"
}

output "domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFront domain name"
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "Hosted zone ID for alias records"
}

output "oai_iam_arn" {
  value       = aws_cloudfront_origin_access_identity.this.iam_arn
  description = "OAI IAM ARN"
}

output "oai_s3_canonical_user_id" {
  value       = aws_cloudfront_origin_access_identity.this.s3_canonical_user_id
  description = "OAI S3 canonical user id"
}
