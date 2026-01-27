locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"

  #! TODO: refactor me somehow?

  all_vlans = [for vlan in local.vlans : vlan.name]
  vlans = {
    "Trusted" = {
      name          = "Trusted"
      vlan_id       = 1969
      network       = "192.168.69.0"
      cidr_suffix   = "24"
      gateway       = "192.168.69.1"
      dhcp_pool     = ["192.168.69.190-192.168.69.199"]
      dns_servers   = ["192.168.69.1"]
      domain        = "trst.h.mirceanton.com"
      static_leases = {}
    },
    "Untrusted" = {
      name          = "Untrusted"
      vlan_id       = 1942
      network       = "192.168.42.0"
      cidr_suffix   = "24"
      gateway       = "192.168.42.1"
      dhcp_pool     = ["192.168.42.100-192.168.42.199"]
      dns_servers   = ["192.168.42.1"]
      domain        = "utrst.h.mirceanton.com"
      static_leases = {}
    },
    "Guest" = {
      name          = "Guest"
      vlan_id       = 1742
      network       = "172.16.42.0"
      cidr_suffix   = "24"
      gateway       = "172.16.42.1"
      dhcp_pool     = ["172.16.42.10-172.16.42.250"]
      dns_servers   = ["1.1.1.1", "1.0.0.1", "8.8.8.8"]
      domain        = "gst.h.mirceanton.com"
      static_leases = {}
    },

    "Services" = {
      name          = "Services"
      vlan_id       = 1010
      network       = "10.0.10.0"
      cidr_suffix   = "24"
      gateway       = "10.0.10.1"
      dhcp_pool     = ["10.0.10.195-10.0.10.199"]
      dns_servers   = ["10.0.10.1"]
      domain        = "svc.h.mirceanton.com"
      static_leases = {}
    },
    "Management" = {
      name          = "Management"
      vlan_id       = 1000
      network       = "10.0.0.0"
      cidr_suffix   = "24"
      gateway       = "10.0.0.1"
      dhcp_pool     = ["10.0.0.195-10.0.0.199"]
      dns_servers   = ["10.0.0.1"]
      domain        = "srv.h.mirceanton.com"
      static_leases = {}
    },
    "Storage" = {
      name          = "Storage"
      vlan_id       = 1255
      network       = "10.255.255.0"
      cidr_suffix   = "24"
      gateway       = "10.255.255.1"
      dhcp_pool     = ["10.255.255.195-10.255.255.199"]
      dns_servers   = ["10.255.255.1"]
      domain        = "stor.h.mirceanton.com",
      static_leases = {}
    }
  }
}
