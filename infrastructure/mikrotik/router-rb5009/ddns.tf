resource "routeros_ip_cloud" "cloud" {
  ddns_enabled         = "yes"
  update_time          = true
  ddns_update_interval = "1m"
}