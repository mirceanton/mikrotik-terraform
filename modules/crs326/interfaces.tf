# =================================================================================================
# Ethernet Interfaces
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_ethernet
# =================================================================================================
resource "routeros_interface_ethernet" "nas-management" {
  factory_name = "ether1"
  name         = "ether1"
  comment      = "NAS Onboard NIC"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "kube01" {
  factory_name = "ether2"
  name         = "ether2"
  comment      = "Kube Node 01 (node in 3u chassis)"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "kube02" {
  factory_name = "ether3"
  name         = "ether3"
  comment      = "Kube Node 02 (bottom node 2U)"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "kube03" {
  factory_name = "ether4"
  name         = "ether4"
  comment      = "Kube Node 03 (top node 2U)"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "kube04" {
  factory_name = "ether5"
  name         = "ether5"
  comment      = "Kube Node 04 (2U short)"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "virt-1" {
  factory_name = "ether6"
  name         = "ether6"
  comment      = "Virtualization Server Onboard NIC L"
  l2mtu        = 1514
}


resource "routeros_interface_ethernet" "tesmart" {
  factory_name = "ether7"
  name         = "ether7"
  comment      = "TeSmart KVM"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ipkvm" {
  factory_name = "ether8"
  name         = "ether8"
  comment      = "BliKVM"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "nas-data-1" {
  factory_name = "ether9"
  name         = "ether9"
  comment      = "NAS Data 1"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "virt-2" {
  factory_name = "ether10"
  name         = "ether10"
  comment      = "Virtualization Server Onboard NIC R"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "home-assistant" {
  factory_name = "ether11"
  name         = "ether11"
  comment      = "HomeAssistant"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether12" {
  factory_name = "ether12"
  name         = "ether12"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether13" {
  factory_name = "ether13"
  name         = "ether13"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether14" {
  factory_name = "ether14"
  name         = "ether14"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether15" {
  factory_name = "ether15"
  name         = "ether15"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether16" {
  factory_name = "ether16"
  name         = "ether16"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether17" {
  factory_name = "ether17"
  name         = "ether17"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether18" {
  factory_name = "ether18"
  name         = "ether18"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether19" {
  factory_name = "ether19"
  name         = "ether19"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether20" {
  factory_name = "ether20"
  name         = "ether20"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether21" {
  factory_name = "ether21"
  name         = "ether21"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether22" {
  factory_name = "ether22"
  name         = "ether22"
  comment      = ""
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "uplink" {
  factory_name = "ether23"
  name         = "ether23"
  comment      = "Uplink"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "mirkputer" {
  factory_name = "ether24"
  name         = "ether24"
  comment      = "mirkputer"
  l2mtu        = 1514
}


resource "routeros_interface_ethernet" "crs317-1" {
  factory_name             = "sfp-sfpplus1"
  name                     = "sfp-sfpplus1"
  comment                  = "Uplink to CRS317 on Port 15 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}
resource "routeros_interface_ethernet" "crs317-2" {
  factory_name             = "sfp-sfpplus2"
  name                     = "sfp-sfpplus2"
  comment                  = "Uplink to CRS317 on Port 16 (LAGG Member, Trunk Port)"
  l2mtu                    = 1514
  sfp_shutdown_temperature = 90
}
