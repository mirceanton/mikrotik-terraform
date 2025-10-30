terraform {
  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "2.2.0"
    }
  }
}

provider "onepassword" {
  service_account_token = var.op_service_account_token
}
