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
    # TrueNAS Service Records
    "registry.home.mirceanton.com" = { cname = "registry.nas.svc.h.mirceanton.com", type = "CNAME", comment = "TrueNAS Container Registry", match_subdomain = true }
    "s3.home.mirceanton.com"       = { cname = "s3.nas.svc.h.mirceanton.com", type = "CNAME", comment = "TrueNAS S3 Storage", match_subdomain = true }

    # BomkPrinter CNAME
    "bomkprinter.home.mirceanton.com" = { cname = "bomkprinter.utrst.h.mirceanton.com", type = "CNAME", comment = "Bomk Printer" }
  }
}
