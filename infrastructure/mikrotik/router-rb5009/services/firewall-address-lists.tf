resource "routeros_ip_firewall_addr_list" "services" {
  list     = "services"
  comment  = "IPs allocated to K8S Services."
  address  = "10.0.10.250-10.0.10.254"
}
