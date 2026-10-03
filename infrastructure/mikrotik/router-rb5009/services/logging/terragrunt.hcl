include "root" { path = find_in_parent_folders("root.hcl") }
include "provider" { path = find_in_parent_folders("provider.hcl") }

dependencies {
  paths = [find_in_parent_folders("mikrotik/router-rb5009")]
}

terraform {
  source = "./"
}

inputs = {
  nas_ip = "10.0.10.245"
}