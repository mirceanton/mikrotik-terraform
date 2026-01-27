include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-base")]
}

terraform {
  source = find_in_parent_folders("modules/mikrotik-dns-server")
}

inputs = {
  upstream_dns = ["1.1.1.1", "8.8.8.8"]
  adlist_url   = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

  static_dns = {
    "bmc.nas.mgmt.h.mirceanton.com" = { address = "10.0.0.10", type = "A", comment = "TrueNAS BMC" }

    # TrueNAS
    "nas.trst.h.mirceanton.com"  = { address = "192.168.69.245", type = "A", comment = "TrueNAS Trusted" }
    "nas.utrst.h.mirceanton.com" = { address = "192.168.42.245", type = "A", comment = "TrueNAS Untrusted" }
    "nas.stor.h.mirceanton.com"  = { address = "10.255.255.245", type = "A", comment = "TrueNAS Storage" }
    "nas.mgmt.h.mirceanton.com"  = { address = "10.0.0.245", type = "A", comment = "TrueNAS Management", match_subdomain = true }
    "nas.svc.h.mirceanton.com"   = { address = "10.0.10.245", type = "A", comment = "TrueNAS Services", match_subdomain = true }

    # TrueNAS Service Records
    "registry.home.mirceanton.com" = { cname = "registry.nas.svc.h.mirceanton.com", type = "CNAME", comment = "TrueNAS Container Registry", match_subdomain = true }
    "s3.home.mirceanton.com"       = { cname = "s3.nas.svc.h.mirceanton.com", type = "CNAME", comment = "TrueNAS S3 Storage", match_subdomain = true }

    # Kube Clusters
    "k8s-home.mgmt.h.mirceanton.com"  = { address = "10.0.0.30", type = "A", comment = "HomeOps K8S API Endpoint" }
    "k8s-infra.mgmt.h.mirceanton.com" = { address = "10.0.0.15", type = "A", comment = "InfraOps K8S API Endpoint" }

    # BomkPrinter
    "bomkprinter.utrst.h.mirceanton.com" = { address = "192.168.42.180", type = "A", comment = "Bomk Printer" }
    "bomkprinter.home.mirceanton.com"    = { cname = "bomkprinter.utrst.h.mirceanton.com", type = "CNAME", comment = "Bomk Printer" }

    # Proxmox
    "pve.mgmt.h.mirceanton.com"   = { address = "10.0.0.20", type = "A", comment = "Proxmox Cluster Management Interface" }
    "pve01.mgmt.h.mirceanton.com" = { address = "10.0.0.21", type = "A", comment = "Proxmox Node 1 Management Interface" }
    "pve02.mgmt.h.mirceanton.com" = { address = "10.0.0.22", type = "A", comment = "Proxmox Node 2 Management Interface" }
    "pve03.mgmt.h.mirceanton.com" = { address = "10.0.0.23", type = "A", comment = "Proxmox Node 3 Management Interface" }
    "pve01.stor.h.mirceanton.com" = { address = "10.255.255.21", type = "A", comment = "Proxmox Node 1 Storage Interface" }
    "pve02.stor.h.mirceanton.com" = { address = "10.255.255.22", type = "A", comment = "Proxmox Node 2 Storage Interface" }
    "pve03.stor.h.mirceanton.com" = { address = "10.255.255.23", type = "A", comment = "Proxmox Node 3 Storage Interface" }
  }
}
