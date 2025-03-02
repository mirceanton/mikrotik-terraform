module "dhcp-server" {
  for_each = var.vlans
  source   = "./modules/dhcp-server"

  interface_name = each.value.name
  network        = "${each.value.network}/${each.value.cidr_suffix}"
  gateway        = each.value.gateway
  dhcp_pool      = each.value.dhcp_pool
  dns_servers    = each.value.dns_servers
  domain         = each.value.domain
  static_leases  = each.value.static_leases
}

# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "this" {
  for_each  = var.vlans
  address   = "${each.value.gateway}/${each.value.cidr_suffix}"
  interface = each.value.name
  network   = each.value.network
}
