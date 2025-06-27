resource "routeros_ip_firewall_addr_list" "k8s_services" {
  list     = "k8s_services"
  comment  = "IPs allocated to K8S Services."
  address  = "10.0.10.90-10.0.10.99"
}
