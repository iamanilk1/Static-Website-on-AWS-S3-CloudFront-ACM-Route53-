output "zone_id" {
  value       = local.zone_id
  description = "Hosted zone id"
}

output "zone_name" {
  value       = var.hosted_zone_name
  description = "Hosted zone name"
}

output "name_servers" {
  description = "Name servers for the hosted zone (only populated when Terraform created the zone)"
  value       = var.create_zone && var.hosted_zone_id == null ? aws_route53_zone.this[0].name_servers : []
}
