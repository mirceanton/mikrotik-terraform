include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/cloudflare-cname"
}

dependency "router" {
  config_path = "../mikrotik/router-rb5009"

  mock_outputs = {
    ddns_hostname = "example.sn.mynetname.net"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
}