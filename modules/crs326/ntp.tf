# =================================================================================================
# NTP Client
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/system_ntp_client
# =================================================================================================
resource "routeros_system_ntp_client" "client" {
  enabled = true
  mode    = "unicast"
  servers = ["192.168.88.1"]
}
