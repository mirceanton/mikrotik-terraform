generate "backend" {
  path      = "terragrunt_backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
    terraform {
      backend "local" {
        path = "${path_relative_to_include()}/terraform.tfstate"
      }
    }
  EOT
}