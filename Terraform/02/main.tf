provider "azurerm" {
}


# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.deployment_region
}

# Storage Account
resource "azurerm_storage_account" "static_content_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.deployment_region
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
}


resource "null_resource" "static-website" {
  provisioner "local-exec" {
    command = "az storage blob service-properties update --account-name ${azurerm_storage_account.static_content_storage_account.name} --static-website true --index-document index.html --404-document 404.html"
  }
}



resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "ping 127.0.0.1 -n 60 > nul"
  }
  depends_on = [
    null_resource.static-website
  ]
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  resource_group_name    = azurerm_resource_group.resource_group.name
  storage_account_name   = azurerm_storage_account.static_content_storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "./site/index.html"
  depends_on = [
    null_resource.delay
  ]
}

resource "azurerm_storage_blob" "notfound" {
  name                   = "404.html"
  resource_group_name    = azurerm_resource_group.resource_group.name
  storage_account_name   = azurerm_storage_account.static_content_storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "./site/404.html"
  depends_on = [
    null_resource.delay
  ]
}


output "url" {
  value = "https://demoimersao443.z13.web.core.windows.net/"
}