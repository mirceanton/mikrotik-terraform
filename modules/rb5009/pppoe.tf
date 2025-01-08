# =================================================================================================
# PPPoE Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_pppoe_client
# =================================================================================================
resource "routeros_interface_pppoe_client" "digi" {
  interface         = routeros_interface_ethernet.wan.name
  name              = "PPPoE-Digi"
  comment           = "Digi PPPoE Client"
  add_default_route = true
  use_peer_dns      = false
  password          = var.digi_pppoe_password
  user              = var.digi_pppoe_username
}
