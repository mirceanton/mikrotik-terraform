output "ddns_hostname" {
  description = "Mikrotik Cloud DDNS hostname"
  value       = routeros_ip_cloud.cloud.dns_name
  sensitive   = true
}