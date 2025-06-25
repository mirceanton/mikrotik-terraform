include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//infrastructure/mikrotik/router-rb5009/services"

  extra_arguments custom_vars {
    commands = get_terraform_commands_that_need_vars()
  }
}

inputs = {}

dependencies {
  paths = [
    find_in_parent_folders("mikrotik/router-rb5009")
  ]
}
