# =================================================================================================
# DNS Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns
# =================================================================================================
resource "routeros_ip_dns" "dns-server" {
  allow_remote_requests = var.allow_remote_requests
  servers               = var.upstream_dns
  cache_size            = var.cache_size
  cache_max_ttl         = var.cache_max_ttl
}

# =================================================================================================
# AdList
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns_adlist
# =================================================================================================
resource "routeros_ip_dns_adlist" "dns_blocker" {
  count = var.adlist_url != null && var.adlist_url != "" ? 1 : 0

  url        = var.adlist_url
  ssl_verify = var.adlist_ssl_verify
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
