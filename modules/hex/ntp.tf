# =================================================================================================
# NTP Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/system_ntp_client
# =================================================================================================
resource "routeros_system_ntp_client" "client" {
  enabled = true
  mode    = "unicast"
  servers = ["10.0.0.1"]
}