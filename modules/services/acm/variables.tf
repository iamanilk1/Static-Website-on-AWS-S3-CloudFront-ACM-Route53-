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

variable "create_zone" {
  description = "Create the hosted zone if it does not exist"
  type        = bool
  default     = false
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
