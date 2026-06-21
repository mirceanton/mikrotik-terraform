locals {
  # Canonical peer definitions, shared between the RouterOS peer config and the
  # 1Password item config (which needs each peer's tunnel address to render a
  # client wireguard.conf).
  peers = {
    "ashome"     = { address = "172.16.69.10/32", extra_routes = ["192.168.10.0/24"], comment = "AS Home" }
    "mirkphone"  = { address = "172.16.69.11/32", extra_routes = [], comment = "Mirkphone" }
    "soarephone" = { address = "172.16.69.12/32", extra_routes = [], comment = "Cristi Soare Mobil" }
    "vladputer"  = { address = "172.16.69.13/32", extra_routes = [], comment = "Vlad Computer" }
    "mirkbook"   = { address = "172.16.69.14/32", extra_routes = [], comment = "Mirk MacBook" }
    "bomkphone"  = { address = "172.16.69.15/32", extra_routes = [], comment = "BomkiPhone" }
    "mogavision" = { address = "172.16.69.16/32", extra_routes = [], comment = "Televizor Moga" }
    "anabook"    = { address = "172.16.69.17/32", extra_routes = [], comment = "Ana Book" }
    "gradphone"  = { address = "172.16.69.18/32", extra_routes = [], comment = "Cristi Gradi Phone" }
  }
}
