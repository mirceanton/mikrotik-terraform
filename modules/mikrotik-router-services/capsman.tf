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
# WiFi Security
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_security
# =================================================================================================
resource "random_string" "untrusted_wifi_password" { length = 32 }
resource "routeros_wifi_security" "untrusted_wifi_password" {
  name                 = "untrusted-wifi-password"
  authentication_types = ["wpa2-psk", "wpa3-psk"]
  passphrase           = random_string.untrusted_wifi_password.result
}

resource "random_string" "guest_wifi_password" { length = 32 }
resource "routeros_wifi_security" "guest_wifi_password" {
  name                 = "guest-wifi-password"
  authentication_types = ["wpa2-psk", "wpa3-psk"]
  passphrase           = random_string.guest_wifi_password.result
}


# =================================================================================================
# WiFi Datapath
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_datapath
# =================================================================================================
resource "routeros_wifi_datapath" "untrusted_tagging" {
  name    = "untrusted-tagging"
  comment = "WiFi -> Untrusted VLAN"
  vlan_id = var.vlans.Untrusted.vlan_id
}
resource "routeros_wifi_datapath" "guest_tagging" {
  name             = "guest-tagging"
  comment          = "WiFi -> Guest VLAN"
  vlan_id          = var.vlans.Guest.vlan_id
  client_isolation = true
}

# =================================================================================================
# WiFi Configurations
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_configuration
# =================================================================================================
resource "routeros_wifi_configuration" "guest" {
  country = "Romania"
  name    = "badoink-guest"
  ssid    = "badoink-guest"
  comment = ""

  channel = {
    config = routeros_wifi_channel.slow.name
  }
  datapath = {
    config = routeros_wifi_datapath.guest_tagging.name
  }
  security = {
    config = routeros_wifi_security.guest_wifi_password.name
  }
}
resource "routeros_wifi_configuration" "untrusted_slow" {
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
    config = routeros_wifi_security.untrusted_wifi_password.name
  }
}
resource "routeros_wifi_configuration" "untrusted_fast" {
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
    config = routeros_wifi_security.untrusted_wifi_password.name
  }
}


# =================================================================================================
# WiFi Provisioning
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/wifi_provisioning
# =================================================================================================
resource "routeros_wifi_provisioning" "slow" {
  action               = "create-dynamic-enabled"
  comment              = routeros_wifi_configuration.untrusted_slow.name
  supported_bands      = [routeros_wifi_channel.slow.band]
  master_configuration = routeros_wifi_configuration.untrusted_slow.name
  slave_configurations = [
    routeros_wifi_configuration.guest.name,
  ]
}
resource "routeros_wifi_provisioning" "fast" {
  action               = "create-dynamic-enabled"
  comment              = routeros_wifi_configuration.untrusted_fast.name
  supported_bands      = [routeros_wifi_channel.fast.band]
  master_configuration = routeros_wifi_configuration.untrusted_fast.name
  slave_configurations = []
}
