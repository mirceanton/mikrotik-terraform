# =================================================================================================
# DNS Server
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dns
# =================================================================================================
resource "routeros_ip_dns" "dns-server" {
  allow_remote_requests = true

  servers = ["1.1.1.1", "8.8.8.8"]

  cache_size    = 2048
  cache_max_ttl = "1d"
}
