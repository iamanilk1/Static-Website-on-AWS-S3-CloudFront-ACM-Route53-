variable "hosted_zone_name" {
  description = "Hosted zone name (must already exist)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted zone id (required)"
  type        = string
}

// Zone creation and protection are handled by the route53_zone module

variable "domain_name" {
  description = "Domain name for records (apex portion)"
  type        = string
}

variable "cf_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "cf_hosted_zone_id" {
  description = "CloudFront hosted zone id"
  type        = string
}

variable "create_apex" {
  description = "Create apex records"
  type        = bool
  default     = true
}

variable "zone_root_on_apex" {
  description = "If true, record name uses zone root (recommended)"
  type        = bool
  default     = true
}

variable "create_www" {
  description = "Create www records"
  type        = bool
  default     = true
}
