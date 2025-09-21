variable "domain_name" {
  description = "Primary domain (apex) for certificate"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name (must exist)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Optional existing Route53 hosted zone id; if set, data lookup is skipped"
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Optional hosted zone id (e.g., from a created module) used when hosted_zone_id is not provided"
  type        = string
  default     = null
}

variable "san_enabled" {
  description = "Enable SANs"
  type        = bool
  default     = true
}

variable "san_names" {
  description = "Subject Alternative Names"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "manage_dns_validation_records" {
  description = "If true, create Route53 DNS validation records and wait for ACM validation. When false, only request the certificate and output required DNS records."
  type        = bool
  default     = true
}
