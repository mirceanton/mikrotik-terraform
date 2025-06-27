resource "routeros_ip_firewall_addr_list" "services" {
  list     = "k8s_services"
  comment  = "IPs allocated to K8S Services."
  address  = "10.0.10.253" #?FIXME
}
