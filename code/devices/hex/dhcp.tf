resource "routeros_ip_dhcp_client" "client" {
  interface = routeros_interface_vlan.servers.name
}