generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("_shared/provider.tf"))
}