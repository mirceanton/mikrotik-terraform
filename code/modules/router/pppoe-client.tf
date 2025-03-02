# =================================================================================================
# PPPoE Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_pppoe_client
# =================================================================================================
resource "routeros_interface_pppoe_client" "client" {
  interface         = var.pppoe_client_interface
  name              = var.pppoe_client_name
  comment           = var.pppoe_client_comment
  add_default_route = var.pppoe_add_default_route
  use_peer_dns      = var.pppoe_use_peer_dns
  user              = var.pppoe_username
  password          = var.pppoe_password
}

