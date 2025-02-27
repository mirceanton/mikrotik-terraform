# =================================================================================================
# Ethernet Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_ethernet
# =================================================================================================
resource "routeros_interface_ethernet" "rack" {
  factory_name = "ether1"
  name         = "ether1"
  comment      = "Rack Downlink"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether2" {
  factory_name = "ether2"
  name         = "ether2"
  comment      = "N/A"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether3" {
  factory_name = "ether3"
  name         = "ether3"
  comment      = "N/A"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "uplink" {
  factory_name = "ether4"
  name         = "ether4"
  comment      = "Router Uplink"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "smarttv" {
  factory_name = "ether5"
  name         = "ether5"
  comment      = "Living Room TV"
  l2mtu        = 1514
}
