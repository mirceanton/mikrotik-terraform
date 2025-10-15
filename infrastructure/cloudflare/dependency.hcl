dependency "router" {
  config_path = find_in_parent_folders("mikrotik/router-services")

  mock_outputs = {
    ddns_hostname = "example.sn.mynetname.net"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
}
