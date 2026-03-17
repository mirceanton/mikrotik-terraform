include "root" { path = find_in_parent_folders("root.hcl") }
include "zone" {
  path   = find_in_parent_folders("zone.hcl")
  expose = true
}

dependency "cloud" {
  config_path = find_in_parent_folders("mikrotik/router-rb5009/services/cloud")
}

terraform {
  source = find_in_parent_folders("modules/cloudflare-cname")
}

inputs = {
  name    = "vpn"
  zone_name = include.zone.locals.domain
  target  = dependency.cloud.outputs.dns_name
}
