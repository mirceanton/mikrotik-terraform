terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    env_vars = {
      TF_VAR_mikrotik_username       = get_env("MIKROTIK_USERNAME")
      TF_VAR_mikrotik_password       = get_env("MIKROTIK_PASSWORD")
      TF_VAR_digi_pppoe_username     = get_env("DIGI_PPOE_USERNAME")
      TF_VAR_digi_pppoe_password     = get_env("DIGI_PPOE_PASSWORD")
      TF_VAR_untrusted_wifi_password = get_env("UNTRUSTED_WIFI_PASSWORD")
      TF_VAR_guest_wifi_password     = get_env("GUEST_WIFI_PASSWORD")
      TF_VAR_iot_wifi_password       = get_env("IOT_WIFI_PASSWORD")
      TF_VAR_cloudflare_api_token    = get_env("CLOUDFLARE_API_TOKEN")
    }
  }
}

remote_state {
  backend = "local"
  config = {
    path = "$.states/{path_relative_to_include()}/terraform.tfstate"
  }
}
