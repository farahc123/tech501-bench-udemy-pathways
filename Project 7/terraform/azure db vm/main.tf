provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
  subscription_id = var.subscription_id
}

# Referencing my SSH public key, already added in Azure
data "azurerm_ssh_public_key" "tech501-farah-az-key" {
  name                = var.azurerm_ssh_public_key
  resource_group_name = var.resource_group_name
}
#Referencing my already existing private subnet
data "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
}

resource "azurerm_network_interface" "tech501-farah-tf-udemy-db-vm-NIC" {
  name                = "tech501-farah-tf-udemy-db-vm-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  # No public IP provided below
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Settings for the machine itself
resource "azurerm_virtual_machine" "tech501-farah-tf-udemy-db-vm" {
  name                             = var.db_VM_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [azurerm_network_interface.tech501-farah-tf-udemy-db-vm-NIC.id]
  vm_size                          = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name          = "tech501-farah-tf-udemy-db-vm-os-disk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = 30
  }

  os_profile {
    computer_name  = var.db_VM_name
    admin_username = var.admin_username
    custom_data    = <<-EOF
      #!/bin/bash

      # Define log file
      LOG_FILE="/farah_custom_data.log"

      # Redirect output & errors to the log file
      exec > >(tee -a "$LOG_FILE") 2>&1

      # get updates of packages with no user input
      echo "Updating package lists..."
      sudo apt update -y

      # downloads and installs the latest updates for packages
      echo "Upgrading installed packages..."
      sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

      # installs gnupg and curl
      echo "Installing gnupg and curl..."
      sudo DEBIAN_FRONTEND=noninteractive apt install gnupg curl -y

      # downloads gpg key
      echo "Downloading and adding MongoDB GPG key..."
      curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
      sudo gpg --batch --yes -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

      # creates file list
      echo "Adding MongoDB repository..."
      echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

      # updates packages again
      echo "Updating package lists again..."
      sudo apt update -y

      # installs MongoDB components
      echo "Installing MongoDB 7.0.6 components..."
      sudo apt install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

      # changes the bindIP default setting
      echo "Updating MongoDB bindIp setting to listen to all sources..."
      sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

      # enabling mongod to start on boot, starts it
      echo "Enabling MongoDB service..."
      sudo systemctl enable mongod

      # checking if mongod is enabled
      echo "Checking if MongoDB service is enabled..."
      sudo systemctl is-enabled mongod

      # restarting mongodb to save new enabled setting
      echo "Restarting MongoDB service..."
      sudo systemctl restart mongod

      echo "Script execution completed. Logs stored in $LOG_FILE"
    EOF
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = data.azurerm_ssh_public_key.tech501-farah-az-key.public_key
    }
  }
}