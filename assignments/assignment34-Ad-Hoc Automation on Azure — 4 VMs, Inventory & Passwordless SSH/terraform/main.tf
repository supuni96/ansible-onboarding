provider "azurerm" {
  features {}
  subscription_id = "3db92bb7-a8eb-4637-8bee-77845e96329e"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "ansible-test-rg"
  location = "EastUS"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "ansible-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "ansible-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "ansible-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IPs
resource "azurerm_public_ip" "pub_ip" {
  count               = 3
  name                = "ansible-pubip-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Network Interfaces
resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "ansible-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub_ip[count.index].id
  }
}

# Associate NSG with each NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  count                     = 3
  network_interface_id       = azurerm_network_interface.nic[count.index].id
  network_security_group_id  = azurerm_network_security_group.nsg.id
}

# Linux VMs
resource "azurerm_linux_virtual_machine" "vm" {
  count               = 3
  name                = "ansible-vm${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# Output public IPs
output "vm_public_ips" {
  value = azurerm_public_ip.pub_ip[*].ip_address
}
