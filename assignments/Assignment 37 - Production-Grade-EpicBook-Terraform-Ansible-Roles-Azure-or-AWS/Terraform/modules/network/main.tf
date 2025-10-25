resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env}-vnet"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# Public subnet for VM
resource "azurerm_subnet" "public" {
  name                 = "${var.env}-public-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Private subnet for DB (delegated)
resource "azurerm_subnet" "private" {
  name                 = "${var.env}-mysql-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "delegation-mysql-flexible"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Network Security Group for public subnet
resource "azurerm_network_security_group" "nsg_public" {
  name                = "${var.env}-nsg-public"
  resource_group_name = var.rg_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_network_security_group" "nsg_private" {
  name                = "${var.env}-nsg-private"
  resource_group_name = var.rg_name
  location            = var.location
  tags                = var.tags
}


# NSG rules
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "${var.env}-allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.allowed_ssh_ip
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg_public.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "${var.env}-allow-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg_public.name
}

# Private NSG: allow MySQL only from public subnet
resource "azurerm_network_security_rule" "allow_mysql_from_public_subnet" {
  name                        = "${var.env}-allow-mysql"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "public_assoc" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}

resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

# Public IP & NIC used by VM
resource "azurerm_public_ip" "vm_pip" {
  name                = "${var.env}-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  tags                = var.tags
  sku                 = "Standard"
}

resource "azurerm_network_interface" "public_nic" {
  name                = "${var.env}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
  tags = var.tags
}
