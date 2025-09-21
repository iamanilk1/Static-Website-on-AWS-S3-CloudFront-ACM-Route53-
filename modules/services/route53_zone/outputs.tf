output "zone_id" {
  value       = aws_route53_zone.this.zone_id
  description = "Hosted zone id"
}

output "name_servers" {
  value       = aws_route53_zone.this.name_servers
  description = "Name servers for delegation"
}
