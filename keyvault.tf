resource "azurerm_key_vault" "opus-kv" {
  name                            = "opus-${var.env_name}-kv"
  location                        = "${var.location}"
  resource_group_name             = "${azurerm_resource_group.opus_rg.name}"
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = "${var.tenant_id}"

  sku {
    name = "standard"
  }

  tags {
    environment = "Development"
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "example" {
  vault_name          = "${azurerm_key_vault.opus-kv.name}"
  resource_group_name = "${azurerm_key_vault.opus-kv.resource_group_name}"

  tenant_id = "${var.tenant_id}"
  object_id = "${var.object_id}"

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]

  certificate_permissions = [
    "get",
  ]
}
