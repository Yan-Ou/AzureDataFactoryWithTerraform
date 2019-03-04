# resource "azurerm_databricks_workspace" "opus-databricks" {
#   name                = "opus-${var.env_name}-databricks"
#   resource_group_name = "${azurerm_resource_group.opus_rg.name}"
#   location            = "${var.location}"
#   sku                 = "Standard"
# }

resource "azurerm_template_deployment" "opus-databricks" {
  name                = "opus-${var.env_name}-databricks"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  template_body = <<DEPLOY
  {
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
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
    "pricingTier": {
      "type": "string",
      "defaultValue": "premium",
      "allowedValues": [
        "standard",
        "premium"
      ],
      "metadata": {
        "description": "The pricing tier of workspace."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources."
      }
    }
  },
  "variables": {
    "managedResourceGroupName": "[concat('databricks-rg-', variables('workspaceName'), '-', uniqueString(variables('workspaceName'), resourceGroup().id))]",
    "workspaceName": "[concat('opus-', parameters('env'), '-databricks')]"
  },
  "resources": [
    {
      "type": "Microsoft.Databricks/workspaces",
      "name": "[variables('workspaceName')]",
      "location": "[parameters('location')]",
      "apiVersion": "2018-04-01",
      "sku": {
        "name": "[parameters('pricingTier')]"
      },
      "properties": {
        "ManagedResourceGroupId": "[concat(subscription().id, '/resourceGroups/', variables('managedResourceGroupName'))]"
      }
    }
  ],
  "outputs": {
    "workspace": {
      "type": "object",
      "value": "[reference(resourceId('Microsoft.Databricks/workspaces', variables('workspaceName')))]"
    }
  }
}
DEPLOY

  parameters {
    env         = "${var.env_name}"
    pricingTier = "standard"
  }

  deployment_mode = "Incremental"
}
