resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.env}-vm"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.vm_user
  admin_password      = var.vm_password

  network_interface_ids = [var.public_nic_id]

  admin_ssh_key {
  username   = var.vm_user
  public_key = file("${path.module}/id_rsa.pub")
}


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # cloud-init script to install dependencies and deploy EpicBook
  custom_data = base64encode(<<-EOF
    #cloud-config
    package_update: true
    packages:
      - git
      - nodejs
      - npm
      - nginx
      - default-mysql-client
    runcmd:
      - cd /home/${var.vm_user}
      - git clone https://github.com/pravinmishraaws/theepicbook.git || true
      - cd theepicbook || true
      - npm install || true
      - nohup node server.js > /tmp/epicbook.log 2>&1 &
  EOF
  )

  tags = var.tags
}

