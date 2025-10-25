# Resource group created in root and passed to modules
resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = local.location
  tags     = local.tags
}

module "network" {
  source         = "./modules/network"
  rg_name        = azurerm_resource_group.rg.name
  location       = local.location
  env            = local.prefix
  allowed_ssh_ip = var.allowed_ssh_ip
  tags           = local.tags
}

module "database" {
  source = "git::https://github.com/supuni96/Terraform-epicbookdeploy.git//modules/database"
  #source      = "./modules/database"
  rg_name     = azurerm_resource_group.rg.name
  location    = local.location
  env         = local.prefix
  subnet_id   = module.network.private_subnet_id
  db_admin    = var.db_admin
  db_password = var.db_password
  tags        = local.tags
}

module "compute" {
  source          = "./modules/compute"
  rg_name         = azurerm_resource_group.rg.name
  location        = local.location
  env             = local.prefix
  public_nic_id   = module.network.public_nic_id
  public_ip       = module.network.public_ip
  db_host         = module.database.db_fqdn
  vm_user         = var.vm_user
  vm_password     = var.vm_password
  tags            = local.tags
}
