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

provider "routeros" {
  alias   = "rb5009"
  hosturl = "https://10.0.0.1"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = true
}