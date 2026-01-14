# =================================================================================================
# NAT Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_nat
# =================================================================================================
resource "routeros_ip_firewall_nat" "hairpin" {
  comment            = "Hairpin NAT - allows LAN clients to access services via public IP"
  chain              = "srcnat"
  action             = "masquerade"
  in_interface_list  = routeros_interface_list.lan.name
  out_interface_list = routeros_interface_list.lan.name
}

resource "routeros_ip_firewall_nat" "wan" {
  comment            = "WAN masquerade"
  chain              = "srcnat"
  action             = "masquerade"
  out_interface_list = routeros_interface_list.wan.name
  place_before       = routeros_ip_firewall_nat.hairpin.id
}
