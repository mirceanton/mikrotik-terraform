include "root" {
  path = find_in_parent_folders()
}

inputs = {
  mikrotik_username       = get_env("MIKROTIK_USERNAME")
  mikrotik_password       = get_env("MIKROTIK_PASSWORD")
  digi_pppoe_username     = get_env("DIGI_PPOE_USERNAME")
  digi_pppoe_password     = get_env("DIGI_PPOE_PASSWORD")
  untrusted_wifi_password = get_env("UNTRUSTED_WIFI_PASSWORD")
  guest_wifi_password     = get_env("GUEST_WIFI_PASSWORD")
  iot_wifi_password       = get_env("IOT_WIFI_PASSWORD")
}