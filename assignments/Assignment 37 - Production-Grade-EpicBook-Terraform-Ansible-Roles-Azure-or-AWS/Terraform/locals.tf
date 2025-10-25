locals {
  location    = "Southeast Asia"
  prefix      = "${terraform.workspace == "default" ? "dev" : terraform.workspace}-epicbook"
  tags = {
    project = "multicloud-foundation"
    owner   = "Supuni"
    env     = terraform.workspace == "default" ? "dev" : terraform.workspace
  }
}
