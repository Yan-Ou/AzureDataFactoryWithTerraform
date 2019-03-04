resource "azurerm_network_security_group" "nsg_pri" {
  name                = "opus-${var.env_name}-pri-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.subnet1_cidr}"
    destination_address_prefix = "*"
  }
}
