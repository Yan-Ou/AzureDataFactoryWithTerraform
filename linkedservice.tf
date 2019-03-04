resource "azurerm_template_deployment" "opus-adf-links" {
  name                = "opus-${var.env_name}-adflinks"
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
        "azureSqlDatabaseConnectionString": {
            "type": "secureString",
            "metadata": "Secure string for 'connectionString' of 'AzureSqlDatabase1'"
        }
    },
    "variables": {
        "factoryName": "[concat('opus-', parameters('env'), '-adf')]",
        "factoryId": "[concat('Microsoft.DataFactory/factories/', variables('factoryName'))]"
    },
    "resources": [
        {
            "name": "[concat(variables('factoryName'), '/opus-', parameters('env'), '-IR')]",
            "type": "Microsoft.DataFactory/factories/integrationRuntimes",
            "apiVersion": "2017-09-01-preview",
            "properties": {
                "type": "SelfHosted",
                "description": "Self-hosted Integration runtime created using ARM template",
                "typeProperties": {}
            },
            "dependsOn": []
        },
        {
            "name": "[concat(variables('factoryName'), '/OpusAzureSqlDatabase1')]",
            "type": "Microsoft.DataFactory/factories/linkedServices",
            "apiVersion": "2017-09-01-preview",
            "properties": {
                "annotations": [],
                "type": "AzureSqlDatabase",
                "typeProperties": {
                    "connectionString": "[parameters('azureSqlDatabaseConnectionString')]"
                },
                "connectVia": {
                    "referenceName": "[concat('opus-', parameters('env'), '-IR')]",
                    "type": "IntegrationRuntimeReference"
                }
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/integrationRuntimes/', 'opus-', parameters('env'), '-IR')]"
            ]
        }
    ]
}
DEPLOY

  parameters {
    env                              = "${var.env_name}"
    azureSqlDatabaseConnectionString = ""
  }

  deployment_mode = "Incremental"
}
