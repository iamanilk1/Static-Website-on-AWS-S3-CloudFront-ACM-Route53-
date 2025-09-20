variable "domain_name" {
  description = "Primary domain (apex) for certificate"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name (must exist)"
  type        = string
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
