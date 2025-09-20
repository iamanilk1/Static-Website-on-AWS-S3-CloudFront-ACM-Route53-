variable "name" {
  description = "Name prefix for the distribution"
  type        = string
}

variable "s3_domain_name" {
  description = "S3 bucket regional domain name for origin"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1"
  type        = string
}

variable "aliases" {
  description = "Custom domain names for CloudFront"
  type        = list(string)
  default     = []
}

variable "comment" {
  description = "Distribution comment"
  type        = string
  default     = "Static site distribution"
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "cache_policy_id" {
  description = "Optional cache policy id; defaults to Managed-CachingOptimized"
  type        = string
  default     = null
}

variable "response_headers_policy_id" {
  description = "Optional response headers policy id"
  type        = string
  default     = null
}

variable "price_class" {
  description = "Price class for CloudFront"
  type        = string
  default     = "PriceClass_100"
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
