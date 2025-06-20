terraform {
  source = "infrastructure"

  before_hook "setup_modules" {
    commands = ["init"]
    execute  = ["ln", "-sf", "${get_terragrunt_dir()}/modules", "modules"]
  }

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
    path = "${get_terragrunt_dir()}/tfstate.json"
  }
}