provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
  subscription_id = var.subscription_id
}

# Referencing the existing resource group
data "azurerm_resource_group" "tech501" {
  name = "tech501"
}

# Virtual Network
resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.tech501.location
  resource_group_name = data.azurerm_resource_group.tech501.name
}

# Public Subnet
resource "azurerm_subnet" "my_public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = data.azurerm_resource_group.tech501.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Private Subnet
resource "azurerm_subnet" "my_private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = data.azurerm_resource_group.tech501.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Network Security Group for Private Subnet
resource "azurerm_network_security_group" "tf_private_nsg" {
  name                = "private-subnet-tf-nsg"
  location            = data.azurerm_resource_group.tech501.location
  resource_group_name = data.azurerm_resource_group.tech501.name

  # Inbound Rules for Private Subnet
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Vnet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound Rules for Private Subnet
  security_rule {
    name                       = "Allow-Vnet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-Internet-Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Deny-All-Outbound"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Public Subnet
resource "azurerm_network_security_group" "tf_public_nsg" {
  name                = "public-subnet-tf-nsg"
  location            = data.azurerm_resource_group.tech501.location
  resource_group_name = data.azurerm_resource_group.tech501.name

  # Inbound Rules for Public Subnet
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-on-3000-reverse-proxy"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Vnet-Inbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound Rules for Public Subnet
  security_rule {
    name                       = "Allow-Vnet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-Internet-Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "Deny-All-Outbound"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSG association
resource "azurerm_subnet_network_security_group_association" "public_subnet_association" {
  subnet_id                 = azurerm_subnet.my_public_subnet.id
  network_security_group_id = azurerm_network_security_group.tf_public_nsg.id
}

# NSG association
resource "azurerm_subnet_network_security_group_association" "private_subnet_association" {
  subnet_id                 = azurerm_subnet.my_private_subnet.id
  network_security_group_id = azurerm_network_security_group.tf_private_nsg.id
}