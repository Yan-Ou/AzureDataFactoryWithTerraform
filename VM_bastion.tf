resource "azurerm_virtual_machine" "opus-bastion" {
  name                  = "opus-${var.env_name}-adminVM"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.opus_rg.name}"
  network_interface_ids = ["${azurerm_network_interface.opus_pip_nic.id}"]
  vm_size               = "Standard_DS1_v2"

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdiskAdmin"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "opus-${var.env_name}-admin"
    admin_username = "${var.admin_username_bastion}"
    admin_password = "${var.admin_password_bastion}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false

    winrm {
      protocol        = "http"
      certificate_url = ""
    }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://${azurerm_storage_account.opus_storage.name}.blob.core.windows.net/"
  }
}
