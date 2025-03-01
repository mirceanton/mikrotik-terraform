locals {
  timezone       = "Europe/Bucharest"
  cloudflare_ntp = "time.cloudflare.com"

  all_vlans = [local.vlans.Guest.name, local.vlans.IoT.name, local.vlans.Kubernetes.name, local.vlans.Servers.name, local.vlans.Trusted.name, local.vlans.Untrusted.name]
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

module "rb5009_mig" {
  source            = "./modules/router"
  mikrotik_ip       = "10.0.0.1"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname    = "Router"
  timezone    = local.timezone
  ntp_servers = [local.cloudflare_ntp]

  pppoe_client_interface = "ether1" # !FIXME
  pppoe_client_comment   = "Digi PPPoE Client"
  pppoe_client_name      = "PPPoE-Digi"
  pppoe_username         = var.digi_pppoe_username
  pppoe_password         = var.digi_pppoe_password

  mdns_repeat_ifaces = [local.vlans.IoT.name, local.vlans.Untrusted.name]
  adlist_url         = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  static_dns = {
    "nas.trst.h.mirceanton.com"  = { address = "192.168.69.245", type = "A", comment = "TrueNAS Trusted" },
    "nas.utrst.h.mirceanton.com" = { address = "192.168.42.245", type = "A", comment = "TrueNAS Untrusted" },
    "nas.k8s.h.mirceanton.com"   = { address = "10.0.10.245", type = "A", comment = "TrueNAS K8S" },
    "nas.srv.h.mirceanton.com"   = { address = "10.0.0.245", type = "A", comment = "TrueNAS Servers" },

    "hass.home.mirceanton.com"    = { address = "192.168.42.253", type = "A", comment = "HomeAssistant Odroid" },
    "truenas.home.mirceanton.com" = { address = "10.0.0.245", type = "A", comment = "TrueNAS Management Interface" },
    "proxmox.home.mirceanton.com" = { address = "10.0.0.240", type = "A", comment = "Proxmox Management Interface" },
  }
}

module "crs326" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.3"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Rach Slow"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = local.vlans.Servers.name

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment  = "Old NAS Onboard", untagged = local.vlans.Servers.name }
    "ether2" = { comment  = "PVE 01 Onboard", untagged = local.vlans.Servers.name }
    "ether3" = { comment  = "PVE 02 Onboard", untagged = local.vlans.Servers.name}
    "ether4" = { comment  = "PVE 03 Onboard", untagged = local.vlans.Servers.name }
    "ether5" = {
      comment  = "New NAS Onboard",
      tagged   = [local.vlans.Trusted.name, local.vlans.Untrusted.name],
      untagged = local.vlans.Servers.name
    }
    "ether6" = {}
    "ether7" = { comment  = "TeSmart KVM", untagged = local.vlans.Servers.name }
    "ether8" = { comment  = "BliKVM", untagged = local.vlans.Servers.name }
    "ether9" = {
      comment = "Old NAS Data 1",
      tagged  = [local.vlans.Kubernetes.name, local.vlans.Untrusted.name, local.vlans.Trusted.name],
    }
    "ether10" = {}
    "ether11" = { comment  = "HomeAssistant", untagged = local.vlans.Untrusted.name }
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
    "ether23" = { comment = "Uplink", tagged  = local.all_vlans }
    "ether24" = { comment  = "mirkputer", untagged = local.vlans.Trusted.name }
    "sfp-sfpplus1" = {}
    "sfp-sfpplus2" = {}
  }
}

module "hex" {
  source            = "./modules/switch"
  mikrotik_ip       = "10.0.0.4"
  mikrotik_username = var.mikrotik_username
  mikrotik_password = var.mikrotik_password
  mikrotik_insecure = true

  hostname              = "Living Room Switch"
  timezone              = local.timezone
  ntp_servers           = [local.cloudflare_ntp]
  dhcp_client_interface = local.vlans.Servers.name

  vlans = local.vlans
  ethernet_interfaces = {
    "ether1" = { comment = "Rack Downlink", tagged = local.all_vlans }
    "ether2" = {}
    "ether3" = {}
    "ether4" = { comment = "Router Uplink", tagged = local.all_vlans }
    "ether5" = { comment = "Smart TV", untagged = local.vlans.IoT.name }
  }
}