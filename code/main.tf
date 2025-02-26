locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"
  default_mtu    = 1514

  vlans = {
    "Guest" = {
      name          = "Guest"
      vlan_id       = 1742
      network       = "172.16.42.0/24"
      gateway       = "172.16.42.1"
      dhcp_pool     = ["172.16.42.10-172.16.42.250"]
      dns_servers   = ["1.1.1.1", "1.0.0.1", "8.8.8.8"]
      domain        = "gst.h.mirceanton.com"
      static_leases = {}
    },
    "IoT" = {
      name        = "IoT"
      vlan_id     = 1769
      network     = "172.16.69.0/24"
      gateway     = "172.16.69.1"
      dhcp_pool   = ["172.16.69.10-172.16.69.200"]
      dns_servers = ["172.16.69.1"]
      domain      = "iot.h.mirceanton.com"
      static_leases = {
        "172.16.69.250" = { name = "Smart TV", mac = "38:26:56:E2:93:99" }
      }
    },
    "Kubernetes" = {
      name          = "Kubernetes"
      vlan_id       = 1010
      network       = "10.0.10.0/24"
      gateway       = "10.0.10.1"
      dhcp_pool     = ["10.0.10.195-10.0.10.199"]
      dns_servers   = ["10.0.10.1"]
      domain        = "k8s.h.mirceanton.com"
      static_leases = {}
    },
    "Servers" = {
      name        = "Servers"
      vlan_id     = 1000
      network     = "10.0.0.0/24"
      gateway     = "10.0.0.1"
      dhcp_pool   = ["10.0.0.195-10.0.0.199"]
      dns_servers = ["10.0.0.1"]
      domain      = "srv.h.mirceanton.com"
      static_leases = {
        "10.0.0.2"   = { name = "CRS317", mac = "D4:01:C3:02:5D:52" }
        "10.0.0.3"   = { name = "CRS326", mac = "D4:01:C3:F8:47:04" }
        "10.0.0.4"   = { name = "hex", mac = "F4:1E:57:31:05:44" }
        "10.0.0.5"   = { name = "cAP-AX", mac = "D4:01:C3:01:26:EB" }
        "10.0.0.21"  = { name = "PVE01", mac = "74:56:3C:9E:BF:1A" }
        "10.0.0.22"  = { name = "PVE02", mac = "74:56:3C:99:5B:CE" }
        "10.0.0.23"  = { name = "PVE03", mac = "74:56:3C:B2:E5:A8" }
        "10.0.0.254" = { name = "BliKVM", mac = "12:00:96:6F:5D:51" }
      }
    },
    "Trusted" = {
      name        = "Trusted"
      vlan_id     = 1969
      network     = "192.168.69.0/24"
      gateway     = "192.168.69.1"
      dhcp_pool   = ["192.168.69.190-192.168.69.199"]
      dns_servers = ["192.168.69.1"]
      domain      = "srv.h.mirceanton.com"
      static_leases = {
        "192.168.69.69" = { name = "MirkPuter-10g", mac = "24:2F:D0:7F:FA:1F" }
        "192.168.69.68" = { name = "BomkPuter", mac = "24:4B:FE:52:D0:65" }
      }
    },
    "Untrusted" = {
      name        = "Untrusted"
      vlan_id     = 1942
      network     = "192.168.42.0/24"
      gateway     = "192.168.42.1"
      dhcp_pool   = ["192.168.42.100-192.168.42.199"]
      dns_servers = ["192.168.42.1"]
      domain      = "srv.h.mirceanton.com"
      static_leases = {
        "192.168.42.253" = { name = "HomeAssistant", mac = "00:1E:06:42:C7:73" }
        "192.168.42.69"  = { name = "Mirk Phone", mac = "04:29:2E:ED:1B:4D" }
        "192.168.42.68"  = { name = "Bomk Phone", mac = "5C:70:17:F3:5F:F8" }
      }
    },
  }

}


module "rb5009" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.1"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Router"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]
  vlans       = local.vlans

  ethernet_interfaces = {
    "ether1" = {
      comment = "Digi Uplink (PPPoE)",
    }
    "ether2" = {
      comment  = "Living Room Switch",
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = local.vlans.Servers.name
    }
    "ether3" = {
      comment  = "Sploinkhole",
      untagged = local.vlans.Trusted.name
    }
    "ether4" = {}
    "ether5" = {}
    "ether6" = {}
    "ether7" = {}
    "ether8" = {
      comment  = "Access Point",
      tagged   = [local.vlans.Untrusted.name, local.vlans.Guest.name, local.vlans.IoT.name]
      untagged = local.vlans.Servers.name
    }
    "sfp-sfpplus1" = {}
  }
}

module "hex" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Living Room HEX"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_enabled   = true
  dhcp_client_interface = local.vlans.Servers.name
  vlans                 = local.vlans

  ethernet_interfaces = {
    "ether1" = {
      comment  = "Rack Downlink",
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "ether2" = {}
    "ether3" = {}
    "ether4" = {
      comment  = "Router Uplink",
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "ether5" = {
      comment  = "Smart TV",
      untagged = local.vlans.IoT.name
    }
  }
}

module "crs326" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Rack Slow"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_enabled   = true
  dhcp_client_interface = local.vlans.Servers.name
  vlans                 = local.vlans

  ethernet_interfaces = {
    "ether1" = {
      comment  = "NAS Onboard NIC",
      untagged = local.vlans.Servers.name
    }
    "ether2" = {
      comment  = "Kube Node 01 (node in 3u chassis)",
      untagged = local.vlans.Servers.name
    }
    "ether3" = {
      comment  = "Kube Node 02 (bottom node 2U)",
      untagged = local.vlans.Servers.name
    }
    "ether4" = {
      comment  = "Kube Node 03 (top node 2U)",
      untagged = local.vlans.Servers.name
    }
    "ether5" = {
      comment  = "Kube Node 04 (2U short)",
      tagged   = [local.vlans.Kubernetes.name, local.vlans.Untrusted.name],
      untagged = local.vlans.Servers.name
    }
    "ether6" = {
      comment  = "Virtualization Server Onboard NIC L",
      tagged   = [],
      untagged = ""
    }
    "ether7" = {
      comment  = "TeSmart KVM",
      untagged = local.vlans.Servers.name
    }
    "ether8" = {
      comment  = "BliKVM",
      untagged = local.vlans.Servers.name
    }
    "ether9" = {
      comment = "NAS Data 1",
      tagged  = [local.vlans.Kubernetes.name, local.vlans.Untrusted.name, local.vlans.Trusted.name],
    }
    "ether10" = {
      comment  = "Virtualization Server Onboard NIC R",
      tagged   = [],
      untagged = ""
    }
    "ether11" = {
      comment  = "HomeAssistant",
      untagged = local.vlans.Untrusted.name
    }
    "ether12" = {}
    "ether13" = {}
    "ether14" = {}
    "ether15" = {}
    "ether16" = {}
    "ether17" = {}
    "ether18" = {}
    "ether19" = {}
    "ether20" = {}
    "ether21" = {}
    "ether22" = {}
    "ether23" = {
      comment = "Uplink",
      tagged  = [local.vlans.Trusted.name, local.vlans.Untrusted.name],
    }
    "ether24" = {
      comment  = "mirkputer",
      untagged = local.vlans.Trusted.name
    }
    "sfp-sfpplus1" = {
      comment = "Uplink to CRS317 on Port 15 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus2" = {
      comment = "Uplink to CRS317 on Port 16 (LAGG Member, Trunk Port)",
    }
  }
  bond_interfaces = {
    "bondCRS316" = {
      mode     = "802.3ad"
      comment  = "Uplink to CRS317"
      slaves   = ["sfp-sfpplus1", "sfp-sfpplus2"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name],
      untagged = ""
    }
  }
}

module "crs317" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.2"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Rack Fast"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_enabled   = true
  dhcp_client_interface = local.vlans.Servers.name
  vlans                 = local.vlans


  ethernet_interfaces = {
    "ether1" = {}
    "sfp-sfpplus1" = {
      comment = "NAS Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus2" = {
      comment = "NAS Port 2 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus3" = {
      comment = "Kube-01 Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus4" = {
      comment = "Kube-01 Port 2 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus5" = {
      comment = "Kube-02 Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus6" = {
      comment = "Kube-02 Port 2 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus7" = {
      comment = "Kube-03 Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus8" = {
      comment = "Kube-03 Port 2 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus9" = {
      comment = "Proxmox Server Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus10" = {
      comment = "Proxmox Server Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus11" = {}
    "sfp-sfpplus12" = {}
    "sfp-sfpplus13" = {}
    "sfp-sfpplus14" = {
      comment  = "Mirk Desktop 10g Card (Access Port, Trusted VLAN)",
      mtu      = local.default_mtu,
      untagged = local.vlans.Trusted.name
    }
    "sfp-sfpplus15" = {
      comment = "Uplink to CRS326 on SFP Port 1 (LAGG Member, Trunk Port)",
    }
    "sfp-sfpplus16" = {
      comment = "Uplink to CRS326 on SFP Port 2 (LAGG Member, Trunk Port)",
    }
  }
  bond_interfaces = {
    "bondNAS" = {
      mode     = "802.3ad"
      comment  = "Old NAS"
      slaves   = ["sfp-sfpplus1", "sfp-sfpplus2"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "bondPVE01" = {
      mode     = "802.3ad"
      comment  = "PVE 01"
      slaves   = ["sfp-sfpplus3", "sfp-sfpplus4"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "bondPVE02" = {
      mode     = "802.3ad"
      comment  = "PVE 01"
      slaves   = ["sfp-sfpplus5", "sfp-sfpplus6"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "bondPVE03" = {
      mode     = "802.3ad"
      comment  = "PVE 01"
      slaves   = ["sfp-sfpplus7", "sfp-sfpplus8"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "bondNAS2" = {
      mode     = "802.3ad"
      comment  = "New NAS"
      slaves   = ["sfp-sfpplus9", "sfp-sfpplus10"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
    "bondCRS326" = {
      mode     = "802.3ad"
      comment  = "CRS326 Uplink"
      slaves   = ["sfp-sfpplus15", "sfp-sfpplus16"]
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name]
      untagged = ""
    }
  }
}