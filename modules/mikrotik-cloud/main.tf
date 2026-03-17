# =================================================================================================
# IP Cloud (DDNS)
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_cloud
# =================================================================================================
resource "routeros_ip_cloud" "this" {
  ddns_enabled         = var.ddns_enabled ? "yes" : "no"
  ddns_update_interval = var.ddns_update_interval
  back_to_home_vpn     = var.back_to_home_vpn
  update_time          = var.update_time
}
resource "routeros_ip_cloud_advanced" "this" {
  use_local_address = var.advanced_use_local_address
}

# =================================================================================================
# Outputs
# =================================================================================================
output "dns_name" {
  description = "The DDNS hostname assigned by MikroTik cloud (e.g. <id>.sn.mynetname.net)"
  value       = routeros_ip_cloud.this.dns_name
}
output "public_address" {
  description = "The public IPv4 address reported by MikroTik cloud"
  value       = routeros_ip_cloud.this.public_address
}

output "public_address_ipv6" {
  description = "The public IPv6 address reported by MikroTik cloud"
  value       = routeros_ip_cloud.this.public_address_ipv6
}