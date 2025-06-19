remote_state {
  backend = "local"
  config = {
    path = "$.states/{path_relative_to_include()}/terraform.tfstate"
  }
}
