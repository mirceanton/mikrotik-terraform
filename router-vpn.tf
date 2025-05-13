# DDNS
resource "routeros_ip_cloud" "cloud" {
  provider = routeros.rb5009
  ddns_enabled         = "yes"
  update_time          = true
  ddns_update_interval = "1m"
}
resource "cloudflare_dns_record" "example_dns_record" {
  for_each = {
    main      = data.cloudflare_zone.main
    secondary = data.cloudflare_zone.secondary
  }

  zone_id = each.value.zone_id
  name    = "vpn.${each.value.name}"
  comment = "Terraform: Mikrotik DDNS"
  type    = "CNAME"
  proxied = false
  ttl     = 3600
  content = routeros_ip_cloud.cloud.dns_name
}

# =================================================================================================
# Wireguard Interface
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_wireguard
# =================================================================================================
resource "routeros_interface_wireguard" "wireguard" {
  provider = routeros.rb5009
  name        = "wg0"
  comment     = "Wireguard VPN"
  listen_port = "13231"
  mtu         = 1420
}

# =================================================================================================
# Wireguard IP Address
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address
# =================================================================================================
resource "routeros_ip_address" "wireguard" {
  provider = routeros.rb5009
  address   = "192.168.255.1/24"
  interface = routeros_interface_wireguard.wireguard.name
  comment   = "Wireguard VPN"
  network   = "192.168.255.0"
}
