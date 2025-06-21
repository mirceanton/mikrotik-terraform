include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//infrastructure/mikrotik/switch-crs326"

  extra_arguments custom_vars {
    commands = get_terraform_commands_that_need_vars()
  }
}

inputs = {}

dependencies {
    paths = []
}