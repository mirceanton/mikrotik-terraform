data "cloudflare_zone" "this" {
  filter = {
    name = var.zone_name
  }
}

resource "cloudflare_dns_record" "this" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.name
  ttl     = var.ttl
  type    = "CNAME"
  content = var.target
  proxied = var.proxied
  comment = "Managed by Terraform"
}
