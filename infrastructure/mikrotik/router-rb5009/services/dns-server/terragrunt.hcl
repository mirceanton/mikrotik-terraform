include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("services/pppoe-client")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-dns-server")
}

inputs = {
  upstream_dns = ["1.1.1.1", "8.8.8.8"]
  adlist_url   = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

  static_dns = {
    "k8s-home.mgmt.h.mirceanton.com"  = { address = "10.0.0.30", type = "A", comment = "HomeOps K8S API Endpoint" }
    "bomkprinter.home.mirceanton.com" = { cname = "bomkprinter.utrst.h.mirceanton.com", type = "CNAME", comment = "Bomk Printer" }
  }
}
