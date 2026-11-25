include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

locals {
  mikrotik_globals = read_terragrunt_config(find_in_parent_folders("globals.hcl")).locals

  wireguard_interface = "wg1"
  pppoe_interface     = "PPPoE-Digi"

  mirkphone_ip     = "172.16.69.11"
  mirkbook_ip      = "172.16.69.14"
  kubernetes_gw_ip = "10.0.10.250"
  mqtt_svc_ip      = "10.0.10.252"
  minecraft_svc_ip = "10.0.10.253"
  nas_ip           = "10.255.255.245"
  pn64_ip          = "10.0.10.10"

  zigbee_coordinator_ip = "10.0.0.99"
  bambu_printer_ip      = "192.168.42.181"
  smart_tv_ip           = "192.168.42.250"
  nas_bmc_ip            = "10.0.0.10"
  jetkvm_ip             = "10.0.0.9"
}

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-routeros.git//modules/firewall?ref=v0.4.0"
}

inputs = {
  address_lists = {
    "wireguard-trusted" = {
      comment   = "Personal WireGuard devices with trusted-level access"
      addresses = [local.mirkphone_ip, local.mirkbook_ip]
    }
    "exposed-services" = {
      comment = "Services exposed to other VLANs"
      addresses = [
        local.kubernetes_gw_ip,
        local.mqtt_svc_ip,
        local.minecraft_svc_ip,
        local.nas_ip
      ]
    }
    "home-assistant-devices" = {
      comment   = "Untrusted-VLAN devices Home Assistant (home cluster) talks to directly"
      addresses = [local.bambu_printer_ip, local.smart_tv_ip]
    }
    "mikrotik-devices" = {
      comment   = "MikroTik switches/APs managed by Terragrunt CD (REST API)"
      addresses = ["10.0.0.2", "10.0.0.3", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
    }
    "node-exporter-targets" = {
      comment   = "Hosts outside the cluster whose node-exporter (9100) the home cluster scrapes"
      addresses = ["192.168.42.69", "192.168.42.70"]
    }
  }

  interface_lists = {
    WAN = {
      comment    = "All Public-Facing Interfaces"
      interfaces = [local.pppoe_interface]
    }
    LAN = {
      comment = "All Local Interfaces"
      interfaces = concat(
        ["bridge", local.wireguard_interface],
        [for v in local.mikrotik_globals.vlans : v.name]
      )
    }

    INTERNET_ONLY = {
      comment = "VLANs with internet-only access"
      interfaces = [
        local.mikrotik_globals.vlans.Guest.name,
        local.mikrotik_globals.vlans.Untrusted.name,
        local.mikrotik_globals.vlans.Management.name,
        local.mikrotik_globals.vlans.Services.name,
        local.mikrotik_globals.vlans.Utils.name,
        local.mikrotik_globals.vlans.DMZ.name
      ]
    }
    NFS_CLIENTS = {
      comment = "VLANs allowed NFS access to the NAS"
      interfaces = [
        local.mikrotik_globals.vlans.Services.name,
        local.mikrotik_globals.vlans.Utils.name
      ]
    }
    CLIENTS = {
      comment = "VLANs allowed limited access to exposed services"
      interfaces = [local.mikrotik_globals.vlans.Untrusted.name,
        local.mikrotik_globals.vlans.Management.name,
        local.wireguard_interface
      ]
    }
  }

  nat_rules = {
    "masquerade-wan" = {
      chain              = "srcnat"
      action             = "masquerade"
      out_interface_list = "WAN"
      order              = 100
    }
  }

  filter_rules = {
    # =========================================================================
    # GLOBAL RULES - Forward Chain
    # =========================================================================
    "fasttrack" = {
      chain            = "forward"
      action           = "fasttrack-connection"
      connection_state = "established,related"
      hw_offload       = true
      order            = 100
    }
    "accept-established-related-untracked-forward" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 110
    }
    "asymmetric-routing-fix-trusted-to-mgmt" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Trusted.name
      out_interface    = local.mikrotik_globals.vlans.Management.name
      order            = 120
    }
    "asymmetric-routing-fix-trusted-to-svc" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Trusted.name
      out_interface    = local.mikrotik_globals.vlans.Services.name
      order            = 121
    }
    "asymmetric-routing-fix-mgmt-to-svc" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.mikrotik_globals.vlans.Management.name
      out_interface    = local.mikrotik_globals.vlans.Services.name
      order            = 122
    }
    "asymmetric-routing-fix-wg-to-mgmt" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "invalid"
      in_interface     = local.wireguard_interface
      out_interface    = local.mikrotik_globals.vlans.Management.name
      order            = 123
    }
    "drop-invalid-forward" = {
      chain            = "forward"
      action           = "drop"
      connection_state = "invalid"
      order            = 130
    }

    # =========================================================================
    # GLOBAL RULES - Input Chain
    # =========================================================================
    "accept-capsman-loopback" = {
      chain       = "input"
      action      = "accept"
      dst_address = "127.0.0.1"
      order       = 200
    }
    "allow-LAN-icmp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "icmp"
      in_interface_list = "LAN"
      order             = 210
    }
    "allow-LAN-dhcp-67" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "67"
      in_interface_list = "LAN"
      order             = 211
    }
    "allow-LAN-dhcp-68" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "68"
      in_interface_list = "LAN"
      order             = 212
    }
    "allow-LAN-dns-tcp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "tcp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 213
    }
    "allow-LAN-dns-udp" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 214
    }
    "allow-wireguard-input" = {
      chain    = "input"
      action   = "accept"
      protocol = "udp"
      dst_port = "13231"
      order    = 215
    }
    "accept-router-established-related-untracked" = {
      chain            = "input"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 220
    }

    # =========================================================================
    # ZONE-BASED RULES
    # =========================================================================
    "allow-MANAGEMENT-input" = {
      chain        = "input"
      action       = "accept"
      in_interface = local.mikrotik_globals.vlans.Management.name
      order        = 1100
    }
    "allow-MANAGEMENT-to-LAN" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Management.name
      out_interface_list = "LAN"
      order              = 1110
    }
    "allow-PN64-to-router-api" = {
      comment      = "external-dns (mikrotik webhook) on the home cluster"
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      dst_port     = "443"
      in_interface = local.mikrotik_globals.vlans.Services.name
      src_address  = local.pn64_ip
      order        = 1120
    }

    "allow-WG-TRUSTED-input" = {
      chain            = "input"
      action           = "accept"
      in_interface     = local.wireguard_interface
      src_address_list = "wireguard-trusted"
      order            = 1200
    }
    "allow-WG-TRUSTED-to-everything" = {
      chain            = "forward"
      action           = "accept"
      in_interface     = local.wireguard_interface
      src_address_list = "wireguard-trusted"
      order            = 1300
    }
    "allow-Trusted-through-WG" = {
      chain         = "forward"
      action        = "accept"
      in_interface  = local.mikrotik_globals.vlans.Trusted.name
      out_interface = "wg1"
      order         = 1310
    }

    # Has to stay above allow-INTERNET_ONLY-to-internet, which covers the Management VLAN
    "drop-jetkvm-to-internet" = {
      comment            = "JetKVM must not have internet access"
      chain              = "forward"
      action             = "drop"
      src_address        = local.jetkvm_ip
      out_interface_list = "WAN"
      order              = 1399
    }
    "allow-INTERNET_ONLY-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface_list  = "INTERNET_ONLY"
      out_interface_list = "WAN"
      order              = 1400
    }
    "allow-CLIENTS-to-services" = {
      chain             = "forward"
      action            = "accept"
      in_interface_list = "CLIENTS"
      out_interface     = local.mikrotik_globals.vlans.Services.name
      dst_address_list  = "exposed-services"
      order             = 1401
    }
    "allow-CLIENTS-to-nas" = {
      chain             = "forward"
      action            = "accept"
      in_interface_list = "CLIENTS"
      out_interface     = local.mikrotik_globals.vlans.Storage.name
      dst_address_list  = "exposed-services"
      order             = 1402
    }
    "allow-NFS_CLIENTS-to-nas-nfs" = {
      chain             = "forward"
      action            = "accept"
      protocol          = "tcp"
      dst_port          = "2049"
      in_interface_list = "NFS_CLIENTS"
      out_interface     = local.mikrotik_globals.vlans.Storage.name
      dst_address       = local.nas_ip
      order             = 1404
    }
    "allow-PN64-to-nas-https" = {
      chain         = "forward"
      action        = "accept"
      protocol      = "tcp"
      dst_port      = "443"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      src_address   = local.pn64_ip
      out_interface = local.mikrotik_globals.vlans.Storage.name
      dst_address   = local.nas_ip
      order         = 1405
    }
    "allow-PN64-to-zigbee-coordinator" = {
      comment       = "zigbee2mqtt on the home cluster -> SLZB/Sonoff coordinator"
      chain         = "forward"
      action        = "accept"
      protocol      = "tcp"
      dst_port      = "6638"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      src_address   = local.pn64_ip
      out_interface = local.mikrotik_globals.vlans.Management.name
      dst_address   = local.zigbee_coordinator_ip
      order         = 1406
    }
    "allow-PN64-to-zigbee-coordinator-icmp" = {
      comment       = "blackbox ping probe that gates zigbee2mqtt via KEDA"
      chain         = "forward"
      action        = "accept"
      protocol      = "icmp"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      src_address   = local.pn64_ip
      out_interface = local.mikrotik_globals.vlans.Management.name
      dst_address   = local.zigbee_coordinator_ip
      order         = 1407
    }
    "allow-PN64-to-home-assistant-devices" = {
      comment          = "Home Assistant integrations (bambu_lab MQTT/FTPS/camera, androidtv_remote)"
      chain            = "forward"
      action           = "accept"
      protocol         = "tcp"
      in_interface     = local.mikrotik_globals.vlans.Services.name
      src_address      = local.pn64_ip
      out_interface    = local.mikrotik_globals.vlans.Untrusted.name
      dst_address_list = "home-assistant-devices"
      order            = 1408
    }
    # --- Monitoring from the home cluster (Prometheus / blackbox / ipmi-exporter) ---
    "allow-PN64-to-nas-metrics" = {
      comment       = "node-exporter 9100, cadvisor 8080, smartctl-exporter 9633 on the NAS"
      chain         = "forward"
      action        = "accept"
      protocol      = "tcp"
      dst_port      = "8080,9100,9633"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      src_address   = local.pn64_ip
      out_interface = local.mikrotik_globals.vlans.Storage.name
      dst_address   = local.nas_ip
      order         = 1409
    }
    "allow-PN64-to-nas-bmc-ipmi" = {
      comment       = "ipmi-exporter -> NAS BMC (RMCP+)"
      chain         = "forward"
      action        = "accept"
      protocol      = "udp"
      dst_port      = "623"
      in_interface  = local.mikrotik_globals.vlans.Services.name
      src_address   = local.pn64_ip
      out_interface = local.mikrotik_globals.vlans.Management.name
      dst_address   = local.nas_bmc_ip
      order         = 1410
    }
    "allow-PN64-to-node-exporters" = {
      comment          = "node-exporter on hosts outside the cluster"
      chain            = "forward"
      action           = "accept"
      protocol         = "tcp"
      dst_port         = "9100"
      in_interface     = local.mikrotik_globals.vlans.Services.name
      src_address      = local.pn64_ip
      dst_address_list = "node-exporter-targets"
      order            = 1411
    }
    "allow-PN64-to-mikrotik-api" = {
      comment          = "self-hosted GitHub runners (Terragrunt CD) -> MikroTik REST API"
      chain            = "forward"
      action           = "accept"
      protocol         = "tcp"
      dst_port         = "443"
      in_interface     = local.mikrotik_globals.vlans.Services.name
      src_address      = local.pn64_ip
      out_interface    = local.mikrotik_globals.vlans.Management.name
      dst_address_list = "mikrotik-devices"
      order            = 1413
    }
    "allow-PN64-icmp-to-LAN" = {
      comment            = "blackbox ping probes from the home cluster"
      chain              = "forward"
      action             = "accept"
      protocol           = "icmp"
      in_interface       = local.mikrotik_globals.vlans.Services.name
      src_address        = local.pn64_ip
      out_interface_list = "LAN"
      order              = 1412
    }
    "allow-NAS-to-internet" = {
      chain              = "forward"
      action             = "accept"
      in_interface       = local.mikrotik_globals.vlans.Storage.name
      src_address        = local.nas_ip
      out_interface_list = "WAN"
      order              = 1403
    }

    # ========================================================================
    # DEFAULT DENY
    # =========================================================================
    "drop-all-forward" = {
      chain        = "forward"
      action       = "drop"
      in_interface = "!${local.mikrotik_globals.vlans.Trusted.name}"
      order        = 9000
    }
    "drop-all-input" = {
      chain        = "input"
      action       = "drop"
      in_interface = "!${local.mikrotik_globals.vlans.Trusted.name}"
      order        = 9010
    }
  }
}
