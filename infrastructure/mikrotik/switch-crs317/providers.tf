# =================================================================================================
# Provider Configuration
# =================================================================================================
terraform {
  required_version = "v1.12.2"
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.85.3"
    }
  }
}
