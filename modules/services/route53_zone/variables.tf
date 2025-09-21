variable "hosted_zone_name" {
  description = "Hosted zone name (e.g., example.com)"
  type        = string
}

variable "prevent_zone_destroy" {
  description = "Protect the hosted zone from deletion"
  type        = bool
  default     = true
}
