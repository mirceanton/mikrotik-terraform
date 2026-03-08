terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.99.1"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
