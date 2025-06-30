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

# Referencing my DB image
data "azurerm_image" "tech501_farah_db_image" {
  name                = var.azurerm_image
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "tech501-farah-tf-udemy-db-from-image-vm-NIC" {
  name                = "tech501-farah-tf-udemy-db-from-image-vm-NIC"
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
resource "azurerm_virtual_machine" "tech501-farah-tf-udemy-db-from-image-vm" {
  name                             = var.db_VM_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [azurerm_network_interface.tech501-farah-tf-udemy-db-from-image-vm-NIC.id]
  vm_size                          = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  storage_os_disk {
    name          = "tech501-farah-tf-udemy-db-from-image-vm-os-disk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = 30
  }

  os_profile {
    computer_name  = var.db_VM_name
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = data.azurerm_ssh_public_key.tech501-farah-az-key.public_key
    }
  }

  storage_image_reference {
    id = data.azurerm_image.tech501_farah_db_image.id
  }
}