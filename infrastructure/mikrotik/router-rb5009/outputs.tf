output "ddns_hostname" {
  description = "The DDNS hostname from MikroTik Cloud"
  value       = routeros_ip_cloud.cloud.dns_name
}

