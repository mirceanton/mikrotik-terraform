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
