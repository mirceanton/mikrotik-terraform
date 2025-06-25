data "cloudflare_zone" "this" {
  filter = {
    name   = var.domain
    status = "active"
  }
}
resource "cloudflare_dns_record" "this" {
  zone_id = data.cloudflare_zone.this.zone_id

  name    = "${var.cname}.${data.cloudflare_zone.this.name}"
  content = var.cname_target
  type    = "CNAME"
  proxied = false
  ttl     = 3600
  comment = "Terraform: Mikrotik DDNS"
}