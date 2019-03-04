resource "random_string" "storage_postfix" {
  length  = 8
  special = false
}

resource "azurerm_storage_account" "opus_storage" {
  name                     = "opus${var.env_name}storage${lower(random_string.storage_postfix.result)}"
  resource_group_name      = "${azurerm_resource_group.opus_rg.name}"
  location                 = "${azurerm_resource_group.opus_rg.location}"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "opus_storage_container" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.opus_rg.name}"
  storage_account_name  = "${azurerm_storage_account.opus_storage.name}"
  container_access_type = "private"
}
