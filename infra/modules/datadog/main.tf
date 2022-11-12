terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.30.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.0.0"
    }
  }
}

resource "azapi_resource" "container_app" {
  name      = "app-datadog-agent"
  location  = var.location
  parent_id = var.group_id
  type      = "Microsoft.App/containerApps@2022-03-01"

  response_export_values = ["properties.configuration.ingress.fqdn"]

  body = jsonencode({
    properties : {
      managedEnvironmentId = var.environment
      configuration = {
        ingress = {
          external   = false
          targetPort = 8126
        }
      }
      template = {
        containers = [
          {
            name  = "datadog-agent"
            image = "datadog/agent"
            resources = {
              cpu    = 1.0
              memory = "2.0Gi"
            }
            env = [
              { name = "DD_API_KEY", value = var.dd_api_key },
              { name = "DD_SITE", value = "datadoghq.com" },
              { name = "DD_LOGS_ENABLED", value = "true" },
              { name = "DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL", value = "false" },
              { name = "DD_PROCESS_AGENT_ENABLED", value = "true" },
              { name = "DD_TAGS", value = "env:quarkus-azure" },
              { name = "DD_APM_NON_LOCAL_TRAFFIC", value = "true" },
            ]
          }
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 2
        }
      }
    }
  })
}
