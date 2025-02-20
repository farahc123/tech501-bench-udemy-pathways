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
#Referencing my already existing public subnet
data "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
}

resource "azurerm_public_ip" "tech501-farah-tf-udemy-app-vm-public-ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = var.public_ip_name
}

resource "azurerm_network_interface" "tech501-farah-tf-udemy-app-vm-NIC" {
  name                = "tech501-farah-tf-udemy-app-vm-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Public IP provided below
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tech501-farah-tf-udemy-app-vm-public-ip.id
  }
}

# Settings for the machine itself
resource "azurerm_virtual_machine" "tech501-farah-tf-udemy-app-vm" {
  name                             = var.app_VM_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [azurerm_network_interface.tech501-farah-tf-udemy-app-vm-NIC.id]
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
    name          = "tech501-farah-tf-udemy-app-vm-os-disk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = 30
  }

  os_profile {
    computer_name  = var.app_VM_name
    admin_username = var.admin_username
    custom_data    = <<-EOF
      #!/bin/bash

      # Defines log file
      LOG_FILE="/farah_custom_data.log"

      # Redirects stdout and stderr to the log file
      exec > >(tee -a "$LOG_FILE") 2>&1

      echo "Fetching the latest version of current packages..."
      sudo apt update -y

      echo "Upgrading installed packages..."
      sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

      echo "Installing Nginx..."
      sudo DEBIAN_FRONTEND=noninteractive apt install -yq nginx
      sudo systemctl enable nginx
      sudo systemctl reload nginx

      echo "Configuring Nginx reverse proxy..."
      sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
      echo "Checking Nginx configuration syntax..."
      sudo nginx -t
      echo "Reloading Nginx..."
      sudo systemctl reload nginx

      echo "Downloading and installing Node.js..."
      sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

      echo "Checking Node.js and npm versions..."
      node -v
      npm -v

      echo "Cloning the application repository..."
      sudo git clone https://github.com/farahc123/tech501-sparta-app.git /repo

      echo "Navigating to the app folder and installing npm and pm2..."
      cd /repo/nodejs20-sparta-test-app/app
      sudo chown -R $(whoami) /repo/nodejs20-sparta-test-app
      sudo npm install
      sudo npm audit fix
      sudo npm install pm2 -g

      echo "Setting up database connection..."
      export DB_HOST=mongodb://10.0.3.4:27017/posts

      echo "Seeding the database..."
      node seeds/seed.js

      echo "Stopping the application with PM2 in case it's already running..."
      pm2 delete app.js

      echo "Starting the application with PM2..."
      pm2 start app.js

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