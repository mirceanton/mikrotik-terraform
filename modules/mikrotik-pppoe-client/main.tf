# =================================================================================================
# PPPoE Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_pppoe_client
# =================================================================================================
resource "routeros_interface_pppoe_client" "this" {
  interface         = var.interface
  name              = var.name
  comment           = var.comment
  add_default_route = var.add_default_route
  use_peer_dns      = var.use_peer_dns
  user              = var.username
  password          = var.password
}
