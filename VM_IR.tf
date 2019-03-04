resource "azurerm_virtual_machine" "opus-ir-vm" {
  name                          = "opus-${var.env_name}-IR"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.opus_rg.name}"
  network_interface_ids         = ["${azurerm_network_interface.opus_pri_nic.id}"]
  vm_size                       = "Standard_A3"
  delete_os_disk_on_termination = true

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
    name              = "myosdiskIR0"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "opus-${var.env_name}-IR"
    admin_username = "${var.admin_username_IR}"
    admin_password = "${var.admin_password_IR}"
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

resource "azurerm_template_deployment" "opus-IRInstall" {
  name                = "opus-${var.env_name}-IRInstall"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  template_body = <<DEPLOY
  {
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
     "env": {
      "type": "string",
      "allowedValues": [
        "dev",
        "test",
        "prod"
      ]
    },
    "IRkey": {
      "type": "string"
    },
    "virtualMachineName": {
      "type": "string"
    },
    "existingVnetLocation": {
      "type": "string"
    },
    "scriptUrl": {
      "type": "string"
    }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(parameters('virtualMachineName'), '/' ,parameters('virtualMachineName'), 'installGW')]",
      "apiVersion": "2017-03-30",
      "location": "[parameters('existingVnetLocation')]",
      "tags": {
        "vmname": "[parameters('virtualMachineName')]"
      },
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "CustomScriptExtension",
        "typeHandlerVersion": "1.7",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "fileUris": [
            "[parameters('scriptUrl')]"
          ]
        },
        "protectedSettings": {
          "commandToExecute": "[concat('powershell.exe -ExecutionPolicy Unrestricted -File gatewayInstall.ps1 ', parameters('IRkey'))]"
        }
      }
    }
  ]
}
DEPLOY

  parameters {
    env                  = "${var.env_name}"
    virtualMachineName   = "${azurerm_virtual_machine.opus-ir-vm.name}"
    existingVnetLocation = "${var.location}"
    scriptUrl            = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vms-with-selfhost-integration-runtime/scripts/gatewayInstall.ps1"
    IRkey                = "${azurerm_template_deployment.opus-adf-ir.outputs["iRkey"]}"
  }

  deployment_mode = "Incremental"
  depends_on      = ["azurerm_template_deployment.opus-adf", "azurerm_template_deployment.opus-adf-ir"]
}
