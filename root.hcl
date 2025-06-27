remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    endpoints = {
      s3 = "https://s3.eu-central-003.backblazeb2.com"
    }
    bucket                      = "tfstate-mikrotik-terraform"
    key                         = "${replace(path_relative_to_include(), "infrastructure/", "")}/tfstate.json"
    region                      = "eu-central-1" #? not actually used, but required by the provider
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}