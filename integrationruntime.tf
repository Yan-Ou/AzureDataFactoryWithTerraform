resource "azurerm_template_deployment" "opus-adf-ir" {
  name                = "opus-${var.env_name}-adfIR"
  resource_group_name = "${azurerm_resource_group.opus_rg.name}"

  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "existingDataFactoryName": {
      "type": "string"
    },
    "IntegrationRuntimeName": {
      "type": "string"
    }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.DataFactory/factories/integrationruntimes",
      "apiVersion": "2017-09-01-preview",
      "name": "[concat(parameters('existingDataFactoryName'), '/', parameters('IntegrationRuntimeName'))]",
      "identity": {
                "type": "SystemAssigned"
            },
      "properties": {
        "type": "SelfHosted",
        "description": "Self-hosted Integration runtime created using ARM template"
      }
    }
  ],
  "outputs": {
    "IRkey": {
      "type": "string",
      "value": "[listAuthKeys(resourceId('Microsoft.DataFactory/factories/integrationruntimes', parameters('existingDataFactoryName'), parameters('IntegrationRuntimeName')), '2017-09-01-preview').authKey1]"
    }
  }
}

DEPLOY

  parameters {
    existingDataFactoryName = "opus-${var.env_name}-adf"
    IntegrationRuntimeName  = "opus-${var.env_name}-IR"
  }

  deployment_mode = "Incremental"
  depends_on      = ["azurerm_template_deployment.opus-adf"]
}

output "IRkey" {
  value = "${azurerm_template_deployment.opus-adf-ir.outputs["iRkey"]}"
}
