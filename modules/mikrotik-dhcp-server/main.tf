# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "this" {
  address   = var.address
  interface = var.interface
  network   = split("/", var.network)[0]
}

# =================================================================================================
# DHCP Pool Range
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_pool
# =================================================================================================
resource "routeros_ip_pool" "this" {
  name    = "${var.interface}-dhcp-pool"
  comment = "${var.interface} DHCP Pool"
  ranges  = var.dhcp_pool
}

# =================================================================================================
# DHCP Network Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_network
# =================================================================================================
resource "routeros_ip_dhcp_server_network" "this" {
  comment    = "${var.interface} DHCP Network"
  domain     = var.domain
  address    = var.network
  gateway    = var.gateway
  dns_server = var.dns_servers
}

# =================================================================================================
# DHCP Server Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server
# =================================================================================================
resource "routeros_ip_dhcp_server" "this" {
  name               = var.interface
  comment            = "${var.interface} DHCP Server"
  address_pool       = routeros_ip_pool.this.name
  interface          = var.interface
  client_mac_limit   = 1
  conflict_detection = false
}

# =================================================================================================
# Static DHCP Leases
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_lease
# =================================================================================================
resource "routeros_ip_dhcp_server_lease" "this" {
  for_each    = var.static_leases
  server      = routeros_ip_dhcp_server.this.name
  address     = each.key
  mac_address = each.value.mac
  comment     = each.value.name
}

# =================================================================================================
# Static DNS Records for DHCP Leases
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_record
# =================================================================================================
locals {
  # Per-lease override takes precedence, otherwise fall back to global flag
  leases_with_dns = {
    for ip, lease in var.static_leases : ip => lease
    if coalesce(lease.create_dns_record, var.create_dns_records)
  }
}

resource "routeros_ip_dns_record" "this" {
  for_each = local.leases_with_dns

  name    = "${each.value.name}.${var.domain}"
  address = each.key
  type    = "A"
  comment = "[Auto] DHCP static lease for ${each.value.name}"
}
