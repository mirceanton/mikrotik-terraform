terraform {
  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "3.1.2"
    }
  }
}

provider "onepassword" {
  service_account_token = var.op_service_account_token
}
