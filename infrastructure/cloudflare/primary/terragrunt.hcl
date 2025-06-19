include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = find_in_parent_folders("modules/cloudflare-cname")
}

inputs = {
  cloudflare_api_token = get_env("CLOUDFLARE_API_TOKEN")
  domain               = "mirceanton.com"
  cname                = "vpn"
  cname_target         = dependency.router.outputs.ddns_hostname
}
