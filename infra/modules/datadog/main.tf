terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "1.0.0"
    }
  }
}

variable "environment" {
  type = string
}

resource "azapi_resource" "datadog" {
  name      = "datadog-agent"
  parent_id = var.environment
  type      = "Microsoft.App/managedEnvironments/daprComponents@2022-03-01"

  body = jsonencode({
    properties = {
      componentType = "pubsub.azure.servicebus"
      version       = "v1"
      initTimeout   = "60"
      metadata = [
        {
          name      = "connectionString",
          secretRef = "primary-connection-string"
        }
      ]
      secrets = [
        {
          name  = "primary-connection-string",
          value = var.servicebus_connection_string
        }
      ]
      scopes = [
        "order",
        "delivery"
      ]
    }
  })
}
