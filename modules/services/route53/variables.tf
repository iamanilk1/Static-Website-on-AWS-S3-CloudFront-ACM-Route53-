variable "hosted_zone_name" {
  description = "Hosted zone name (must already exist)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Optional existing hosted zone id; if set, data lookup is skipped"
  type        = string
  default     = null
}

variable "create_zone" {
  description = "Create the hosted zone if it does not exist"
  type        = bool
  default     = false
}

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
