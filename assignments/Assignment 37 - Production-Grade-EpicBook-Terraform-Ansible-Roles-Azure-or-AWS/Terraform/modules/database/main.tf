# MySQL Flexible Server (Private)
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${var.env}-mysqlsupunis"
  resource_group_name    = var.rg_name
  location               = var.location
  version                = "8.0.21"
  sku_name               = "B_Standard_B1ms"   # Correct SKU
  delegated_subnet_id    = var.subnet_id
  administrator_login    = var.db_admin
  administrator_password = var.db_password
  backup_retention_days  = 7

  storage {
    size_gb = 20  # Min allowed by Azure
  }
}


# Private DNS zone will normally be auto created/linked by the provider when using private access
# Output FQDN

