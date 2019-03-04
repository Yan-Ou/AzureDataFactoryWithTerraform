resource "azurerm_sql_server" "opus-sql" {
  name                         = "opus-${var.env_name}-sql"
  resource_group_name          = "${azurerm_resource_group.opus_rg.name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sqladmin}"
  administrator_login_password = "${var.sqladminpassword}"
}

resource "azurerm_sql_virtual_network_rule" "opus-sqlvnetrule" {
  name                = "opus-${var.env_name}-sqlvnetrule"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"
  server_name         = "${azurerm_sql_server.opus-sql.name}"
  subnet_id           = "${azurerm_subnet.opus_pri_subnet.id}"
}
