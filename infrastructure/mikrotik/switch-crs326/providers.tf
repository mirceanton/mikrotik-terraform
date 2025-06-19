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
  address  = "http://10.0.0.3"
  username = var.mikrotik_username
  password = var.mikrotik_password
  insecure = true
}