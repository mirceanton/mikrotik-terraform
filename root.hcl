terraform {
  before_hook "decrypt" {
    commands = ["apply", "plan"]
    execute = ["task", "sops:decrypt"]
  }

  after_hook "encrypt" {
    commands = ["apply", "plan"]
    execute = ["task", "sops:encrypt"]
  }
}

remote_state {
  backend = "local"

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${get_repo_root()}/tfstate/${replace(path_relative_to_include(), "infrastructure/", "")}/tfstate.json"
  }
}