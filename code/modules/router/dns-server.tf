# =================================================================================================
# DNS Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns
# =================================================================================================
resource "routeros_ip_dns" "dns_server" {
  allow_remote_requests = var.dns_allow_remote_requests
  servers               = var.upstream_dns
  cache_size            = var.dns_cache_size
  cache_max_ttl         = var.dns_cache_max_ttl
  mdns_repeat_ifaces    = var.mdns_repeat_ifaces
}


# =================================================================================================
# AdList
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_adlist
# =================================================================================================
resource "routeros_ip_dns_adlist" "dns_blocker" {
  url = var.adlist_url
}


# =================================================================================================
# Static DNS Records
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_record
# =================================================================================================
resource "routeros_ip_dns_record" "static" {
  for_each = var.static_dns
  name     = each.key
  address  = each.value.address
  comment  = each.value.comment
  type     = each.value.type
}