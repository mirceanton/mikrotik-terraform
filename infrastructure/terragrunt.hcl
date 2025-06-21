include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "..//infrastructure"

  extra_arguments custom_vars {
    commands = get_terraform_commands_that_need_vars()
  }
}

inputs = {}

dependencies {
    paths = []
}