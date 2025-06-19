include "root" {
  path = find_in_parent_folders()
}


# TODO: Add a dependency on the RB5009 module, also require the router ddns output as an input to this module.

# TODO: both primary and secondary cloudflare zones are under the same account, so we can use the same credentials for both.
# this means the provider block can be shared across both zones, so we can define it in the root module.