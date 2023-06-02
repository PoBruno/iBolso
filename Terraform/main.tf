provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ibolso" {
  name     = "ibolso-resource-group"
  location = "Brazil South"
}

resource "azurerm_virtual_network" "ibolso" {
  name                = "ibolso-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ibolso.location
  resource_group_name = azurerm_resource_group.ibolso.name
}

resource "azurerm_subnet" "ibolso" {
  name                 = "ibolso-subnet"
  resource_group_name  = azurerm_resource_group.ibolso.name
  virtual_network_name = azurerm_virtual_network.ibolso.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "ibolso" {
  name                = "ibolso-public-ip"
  location            = azurerm_resource_group.ibolso.location
  resource_group_name = azurerm_resource_group.ibolso.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "ibolso" {
  name                = "ibolso-nsg"
  location            = azurerm_resource_group.ibolso.location
  resource_group_name = azurerm_resource_group.ibolso.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "http-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ibolso.name
  network_security_group_name = azurerm_network_security_group.ibolso.name
}

resource "azurerm_network_security_rule" "https" {
  name                        = "https-rule"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ibolso.name
  network_security_group_name = azurerm_network_security_group.ibolso.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh-rule"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ibolso.name
  network_security_group_name = azurerm_network_security_group.ibolso.name
}

resource "azurerm_linux_virtual_machine" "ibolso" {
  name                = "ibolso-vm"
  location            = azurerm_resource_group.ibolso.location
  resource_group_name = azurerm_resource_group.ibolso.name
  size                = "Standard_B1s"
  admin_username      = "User"
  admin_password      = "Password"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.ibolso.id]

  os_disk {
    name              = "ibolso-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}

resource "azurerm_network_interface" "ibolso" {
  name                = "ibolso-nic"
  location            = azurerm_resource_group.ibolso.location
  resource_group_name = azurerm_resource_group.ibolso.name

  ip_configuration {
    name                          = "ibolso-ipconfig"
    subnet_id                     = azurerm_subnet.ibolso.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ibolso.id
  }
}

output "public_ip_address" {
  value = azurerm_public_ip.ibolso.ip_address
}
