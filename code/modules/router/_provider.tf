terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
  }
}

# =================================================================================================
# Provider configuration
# =================================================================================================
provider "routeros" {
  hosturl  = "https://${var.mikrotik_ip}"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = var.mikrotik_insecure
}