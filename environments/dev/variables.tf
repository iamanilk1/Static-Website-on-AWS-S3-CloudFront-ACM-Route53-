variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "static-site"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Primary AWS region for S3/Route53 (ACM/CF use us-east-1)"
  type        = string
  default     = "ap-south-1"
}

variable "domain_name" {
  description = "Apex domain name (e.g., example.com)"
  type        = string
  default     = "iamanilk.com"
}

variable "hosted_zone_name" {
  description = "Hosted zone name (e.g., example.com)"
  type        = string
  default     = "iamanilk.com"
}

variable "hosted_zone_id" {
  description = "Optional existing Route53 hosted zone id"
  type        = string
  default     = null
}

variable "create_zone" {
  description = "Create hosted zone if not found"
  type        = bool
  default     = true
}

variable "prevent_zone_destroy" {
  description = "Protect hosted zone from deletion during destroy"
  type        = bool
  default     = true
}

variable "create_www" {
  description = "Create www record"
  type        = bool
  default     = true
}

variable "create_apex" {
  description = "Create apex A/AAAA records"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "site_dir" {
  description = "Local directory of static files to upload"
  type        = string
  default     = "../../site"
}

variable "upload_enabled" {
  description = "Upload local site_dir to S3"
  type        = bool
  default     = true
}

variable "manage_dns_validation_records" {
  description = "If true, ACM module will create Route53 validation records (one-click)."
  type        = bool
  default     = true
}
