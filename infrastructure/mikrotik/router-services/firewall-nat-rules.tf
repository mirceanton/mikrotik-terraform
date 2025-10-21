# =================================================================================================
# NAT Rules
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_nat
# =================================================================================================
resource "routeros_ip_firewall_nat" "wan" {
  comment            = "Managed by Terraform - WAN masquerade"
  chain              = "srcnat"
  action             = "masquerade"
  out_interface_list = routeros_interface_list.wan.name
}
