include "root" { path = find_in_parent_folders("root.hcl") }
dependency "cloud" { config_path = find_in_parent_folders("mikrotik/router-rb5009/services/cloud") }

terraform {
  source = "git::https://github.com/mirceanton/terraform-modules-cloudflare.git//modules/cloudflare-dns?ref=v0.1.0"
}

inputs = {
  zone_name = "mirceanton.com"
  comment   = "Managed by Terraform in mirceanton/mikrotik-terraform."
  records = {
    "vpn" = {
      type    = "CNAME"
      content = dependency.cloud.outputs.dns_name
    }
  }
}
