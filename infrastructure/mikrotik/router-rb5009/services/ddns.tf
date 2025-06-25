# =================================================================================================
# DDNS - Mikrotik Cloud
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_cloud
# =================================================================================================
resource "routeros_ip_cloud" "cloud" {
  ddns_enabled         = "yes"
  update_time          = true
  ddns_update_interval = "1m"
}
