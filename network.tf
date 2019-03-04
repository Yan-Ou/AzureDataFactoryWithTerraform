# Configure network

resource "azurerm_resource_group" "opus_rg" {
  name     = "opus-${var.env_name}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "opus_vnet" {
  name                = "opus-${var.env_name}-vnet1"
  address_space       = ["${var.vnet_cidr}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  tags {
    group = "Opus"
  }
}

resource "azurerm_subnet" "opus_pub_subnet" {
  name                 = "opus-${var.env_name}-subnet1"
  address_prefix       = "${var.subnet1_cidr}"
  resource_group_name  = "${azurerm_resource_group.opus_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.opus_vnet.name}"
}

resource "azurerm_subnet" "opus_pri_subnet" {
  name                 = "opus-${var.env_name}-subnet2"
  address_prefix       = "${var.subnet2_cidr}"
  resource_group_name  = "${azurerm_resource_group.opus_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.opus_vnet.name}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_public_ip" "opus_pip" {
  name                         = "opus-${var.env_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.opus_rg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "opus_pip_nic" {
  name                = "opus-${var.env_name}-adminNic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.opus_pub_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.opus_pip.id}"
  }
}

resource "azurerm_network_interface" "opus_pri_nic" {
  name                      = "opus-${var.env_name}-IRNic"
  location                  = "${var.location}"
  network_security_group_id = "${azurerm_network_security_group.nsg_pri.id}"
  resource_group_name       = "${azurerm_resource_group.opus_rg.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.opus_pri_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.IR_ip}"
  }
}
