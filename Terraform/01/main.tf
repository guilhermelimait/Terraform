provider "azurerm" {
}

resource "azurerm_resource_group" "rg_demo" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"
}

resource "azurerm_automation_account" "automationaccount_demo" {
  name                = "${var.prefix}-automation01"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_demo.name}"

  sku_name = "Basic"

  tags = "${var.tags}"
}

resource "azurerm_storage_account" "storageaccount_demo" {
  name                     = "${var.prefix}441"
  resource_group_name      = "${azurerm_resource_group.rg_demo.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = "${var.tags}"
}

resource "azurerm_private_dns_zone" "example-private" {
  name                = "mydomain.com"
  resource_group_name = "${azurerm_resource_group.rg_demo.name}"
  tags                = "${var.tags}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_demo.name}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.rg_demo.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_demo.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
  }
  tags = "${var.tags}"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg_demo.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  tags = "${var.tags}"
}