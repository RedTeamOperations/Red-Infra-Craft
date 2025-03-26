terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

/* 
Before Executing this terraform script, you need to create one Service Principal with 
Owner, User Access Administrator, User Administrator, Global Administrator Permissions.
*/

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

variable "subscription_id" {
  description = "Azure Subscription Id"
  type = string
}

variable "client_id" {
  description = "Azure Client Id"
  type = string
}

variable "client_secret" {
  description = "Azure Client Secret"
  type = string
}

variable "tenant_id" {
  description = "Azure Tenant Id"
  type = string
}

variable "vm_key_name" {
  description = "VM Secret File Name"
  type = string
}

# Key Pair
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa-4096.private_key_pem
  filename = var.vm_key_name
}

# 1. Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "Mythic"
  location = "East US"
}


# 1. Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# 3. Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. Create Public IP
resource "azurerm_public_ip" "pip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "mypublicipdns12343131245325675" 
}

# 5. Create Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

}

# 6. Create Virtual Machine with User Data
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "myVM"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                = "Standard_B1ms"

  admin_username = "azureuser"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.rsa-4096.public_key_openssh
  }

  disable_password_authentication = true

  custom_data = base64encode(file("script.sh"))
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "myNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-HTTP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "80"
    source_address_prefix     = "AzureFrontDoor.Backend"
    destination_address_prefix = "*"
    description               = "Allow inbound HTTP traffic using the Http tag"
   
  }

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "443"
    source_address_prefix     = "AzureFrontDoor.Backend"
    destination_address_prefix = "*"
    description               = "Allow inbound HTTPS traffic using the Https tag"
  
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "22"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }
}



data "azurerm_client_config" "current" {}

resource "azurerm_cdn_frontdoor_profile" "example" {
  name                = "example-profile"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_origin_group" "example" {
  name                     = "example-origingroup"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id

  health_probe {
    interval_in_seconds = 240
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }

  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "example" {
  name                          = "example-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name          = azurerm_linux_virtual_machine.vm.public_ip_address
  http_port          = 80
  https_port         = 443
  origin_host_header = azurerm_linux_virtual_machine.vm.public_ip_address
  priority           = 1
  weight             = 1
}

resource "azurerm_cdn_frontdoor_endpoint" "example" {
  name                     = "example-xoxo-testing-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
}

resource "azurerm_cdn_frontdoor_route" "example" {
  name                          = "example-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.example.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.example.id]
  enabled                       = true

  forwarding_protocol    = "HttpOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
}

# Output the public IP of the instance
output "instance_ip" {
  value = <<EOF
************************************************************************
| 🖥️ Machine Ip: ${azurerm_linux_virtual_machine.vm.public_ip_address} |
************************************************************************
EOF
}

# Output the Username of the instance
output "username" {
  value = <<EOF
*************************************
| 👤 Username of Machine: azureuser |
*************************************
EOF
}

# Output the Domain of the CloudFront
output "cloudfront_domain_name" {
  value = <<EOF
*****************************************************************************
| 🌍 CloudFront Domain: ${azurerm_cdn_frontdoor_endpoint.example.host_name} |
*****************************************************************************
EOF
}


output "destroy_infra" {
  value = <<EOF
***********************************************************
| 🗑️	Command: redinfracraft.py destroy azure c2 mythic_lb |
***********************************************************
EOF 
}