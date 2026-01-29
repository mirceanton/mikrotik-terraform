locals {
  mikrotik_hostname = "10.0.0.1"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "routeros" {
      hosturl  = "https://${local.mikrotik_hostname}"
      username = "${get_env("MIKROTIK_USERNAME")}"
      password = "${get_env("MIKROTIK_PASSWORD")}"
      insecure = true
    }
  EOF
}