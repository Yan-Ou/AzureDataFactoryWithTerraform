resource "azurerm_template_deployment" "opus-adf" {
  name                = "opus-${var.env_name}-adf"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  template_body = <<DEPLOY
  {
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "env": {
            "allowedValues": [
                "dev",
                "test",
                "prod"
            ],
            "type": "string"
        },
        "ADFLocation": {
            "allowedValues": [
                "Australia East",
                "Southeast Asia"
            ],
            "type": "string"
        }
    },
    "variables": {
        "ADFName": "[concat('opus-', parameters('env'), '-adf')]",
        "IntegrationRuntimeName": "[concat('opus-', parameters('env'), '-IR')]"
    },
    "resources": [
        {
            "type": "Microsoft.DataFactory/factories",
            "name": "[variables('ADFName')]",
            "apiVersion": "2017-09-01-preview",
            "location": "[parameters('ADFLocation')]",
            "identity": {
                "type": "SystemAssigned"
            }
        }
    ]
}
DEPLOY

  parameters {
    env         = "${var.env_name}"
    ADFLocation = "Southeast Asia"
  }

  deployment_mode = "Incremental"
}
