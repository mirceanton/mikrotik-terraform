module "dhcp-server" {
  for_each  = local.vlans
  source    = "./modules/dhcp-server"
  providers = { routeros = routeros.rb5009 }

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
resource "routeros_ip_address" "rb5009" {
  for_each  = local.vlans
  provider  = routeros.rb5009
  address   = "${each.value.gateway}/${each.value.cidr_suffix}"
  interface = each.value.name
  network   = each.value.network
}
