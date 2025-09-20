output "uploaded_keys" {
  description = "List of uploaded object keys"
  value       = keys(aws_s3_object.this)
}
