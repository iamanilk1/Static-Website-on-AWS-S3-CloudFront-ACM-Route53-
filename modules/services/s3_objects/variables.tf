variable "bucket_id" {
  description = "Target S3 bucket name/id"
  type        = string
}

variable "site_dir" {
  description = "Local directory containing static files"
  type        = string
}

variable "upload_enabled" {
  description = "Enable uploading files to S3"
  type        = bool
  default     = false
}

variable "cache_control" {
  description = "Optional Cache-Control header applied to all objects"
  type        = string
  default     = null
}

variable "content_types" {
  description = "Map of file extension to content-type"
  type        = map(string)
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".txt"  = "text/plain"
  ".xml"  = "application/xml"
  }
}
