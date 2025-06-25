resource "routeros_ip_firewall_addr_list" "k8s_services" {
  list     = "k8s_services"
  comment  = "IPs allocated to K8S Services."
  address  = "10.0.10.90-10.0.10.99"
}
resource "routeros_ip_firewall_addr_list" "iot_internet" {
  list     = "iot_internet"
  comment  = "IoT IPs allowed to the internet."
  address  = "172.16.69.201-172.16.69.250"
}
