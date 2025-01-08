# =================================================================================================
# VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan
# =================================================================================================
resource "routeros_interface_vlan" "kubernetes" {
  interface = routeros_interface_bridge.bridge.name
  name      = "Kubernetes"
  vlan_id   = 1010
}


# =================================================================================================
# IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "kubernetes" {
  address   = "10.0.10.1/24"
  interface = routeros_interface_vlan.kubernetes.name
  network   = "10.0.10.0"
}


# =================================================================================================
# Bridge VLAN Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan
# =================================================================================================
resource "routeros_interface_bridge_vlan" "kubernetes" {
  bridge = routeros_interface_bridge.bridge.name

  vlan_ids = [routeros_interface_vlan.kubernetes.vlan_id]

  tagged = [
    routeros_interface_bridge.bridge.name,
    routeros_interface_ethernet.living_room.name
  ]

  untagged = []
}


# ================================================================================================
# DHCP Server Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_pool
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_network
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server
# ================================================================================================
resource "routeros_ip_pool" "kubernetes_dhcp" {
  name    = "kubernetes-dhcp-pool"
  comment = "kubernetes DHCP Pool"
  ranges  = ["10.0.10.195-10.0.10.199"]
}
resource "routeros_ip_dhcp_server_network" "kubernetes" {
  comment    = "kubernetes DHCP Network"
  domain     = "k8s.home.mirceanton.com"
  address    = "10.0.10.0/24"
  gateway    = "10.0.10.1"
  dns_server = ["10.0.10.1"]
}
resource "routeros_ip_dhcp_server" "kubernetes" {
  name               = "kubernetes"
  comment            = "Kubernetes DHCP Server"
  address_pool       = routeros_ip_pool.kubernetes_dhcp.name
  interface          = routeros_interface_vlan.kubernetes.name
  client_mac_limit   = 1
  conflict_detection = false
}

# ================================================================================================
# Leases for servers DHCP server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_lease
# ================================================================================================
resource "routeros_ip_dhcp_server_lease" "kubernetes" {
  for_each = {
  }
  server = routeros_ip_dhcp_server.kubernetes.name

  mac_address = each.value.mac_address
  address     = each.value.address
  comment     = each.key
}
