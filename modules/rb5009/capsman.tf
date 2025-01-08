# =================================================================================================
# CAPsMAN Settings
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_capsman
# =================================================================================================
resource "routeros_wifi_capsman" "settings" {
  enabled                  = true
  interfaces               = ["all"]
  upgrade_policy           = "none"
  require_peer_certificate = false
}


# =================================================================================================
# WiFi Security
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_security
# =================================================================================================
resource "routeros_wifi_security" "wifi_password" {
  name                 = "wifi-password"
  authentication_types = ["wpa2-psk", "wpa3-psk"]
  passphrase           = var.wifi_password
}


# =================================================================================================
# WiFi Datapath
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_datapath
# =================================================================================================
resource "routeros_wifi_datapath" "untrusted_tagging" {
  name    = "untrusted-tagging"
  comment = "WiFi -> Untrusted VLAN"
  vlan_id = routeros_interface_vlan.untrusted.vlan_id
}


# =================================================================================================
# WiFi Channels
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_channel
# =================================================================================================
resource "routeros_wifi_channel" "slow" {
  name = "2.4ghz"
  band = "2ghz-ax"
}
resource "routeros_wifi_channel" "fast" {
  name = "5ghz"
  band = "5ghz-ax"
}


# =================================================================================================
# WiFi Configurations
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_configuration
# =================================================================================================
resource "routeros_wifi_configuration" "slow" {
  country = "Romania"
  name    = "badoink-2ghz"
  ssid    = "badoink-2ghz"
  comment = ""

  channel = {
    config = routeros_wifi_channel.slow.name
  }
  datapath = {
    config = routeros_wifi_datapath.untrusted_tagging.name
  }
  security = {
    config = routeros_wifi_security.wifi_password.name
  }
}
resource "routeros_wifi_configuration" "fast" {
  country = "Romania"
  name    = "badoink-5ghz"
  ssid    = "badoink-5ghz"
  comment = ""


  channel = {
    config = routeros_wifi_channel.fast.name
  }
  datapath = {
    config = routeros_wifi_datapath.untrusted_tagging.name
  }
  security = {
    config = routeros_wifi_security.wifi_password.name
  }
}


# =================================================================================================
# WiFi Provisioning
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_provisioning
# =================================================================================================
resource "routeros_wifi_provisioning" "slow" {
  action               = "create-dynamic-enabled"
  comment              = routeros_wifi_configuration.slow.name
  master_configuration = routeros_wifi_configuration.slow.name
  supported_bands      = [routeros_wifi_channel.slow.band]
}
resource "routeros_wifi_provisioning" "fast" {
  action               = "create-dynamic-enabled"
  comment              = routeros_wifi_configuration.fast.name
  master_configuration = routeros_wifi_configuration.fast.name
  supported_bands      = [routeros_wifi_channel.fast.band]
}
