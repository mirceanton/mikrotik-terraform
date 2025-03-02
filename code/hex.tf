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
