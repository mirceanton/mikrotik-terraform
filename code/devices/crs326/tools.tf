# =================================================================================================
# Mac Server WinBox
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/tool_mac_server_winbox
# =================================================================================================
resource "routeros_tool_mac_server_winbox" "mac_server_winbox" {
  allowed_interface_list = "all"
}


# =================================================================================================
# MAC Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/tool_mac_server
# =================================================================================================
resource "routeros_tool_mac_server" "mac_server" {
  allowed_interface_list = "all"
}


# =================================================================================================
# BandWidth Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/tool_bandwidth_server
# =================================================================================================
resource "routeros_tool_bandwidth_server" "bandwidth_server" {
  enabled = false
}
