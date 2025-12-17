# =================================================================================================
# DNS Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns
# =================================================================================================
resource "routeros_ip_dns" "dns-server" {
  allow_remote_requests = true
  servers               = var.upstream_dns
  cache_size            = 8192
  cache_max_ttl         = "1d"
}

# =================================================================================================
# AdList
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_adlist
# =================================================================================================
resource "routeros_ip_dns_adlist" "dns_blocker" {
  url        = var.adlist
  ssl_verify = false
}

# =================================================================================================
# Static DNS Records
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_record
# =================================================================================================
resource "routeros_ip_dns_record" "static" {
  for_each = var.static_dns

  name            = each.key
  comment         = each.value.comment
  address         = lookup(each.value, "address", null)
  match_subdomain = lookup(each.value, "match_subdomain", false)
  cname           = lookup(each.value, "cname", null)
  type            = each.value.type
}
