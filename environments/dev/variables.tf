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
}

variable "hosted_zone_name" {
  description = "Hosted zone name (e.g., example.com)"
  type        = string
}

variable "create_www" {
  description = "Create www record"
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
  default     = false
}
