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

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

### Locals ###

locals {
  project           = "quarkus"
  postgres_username = "psqladmin"
  postgres_password = "p4ssw0rd"
}

### Group ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.project}"
  location = var.location
}

### Netowrk ###

module "network" {
  source              = "./modules/network"
  project             = local.project
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
}

### Service Bus ###

# resource "azurerm_servicebus_namespace" "default" {
#   name                = "bus-${local.project}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name

#   # Standard is required for Dapr to use topics
#   sku = "Standard"
# }

# resource "azurerm_servicebus_topic" "default" {
#   name                = "orders"
#   namespace_id        = azurerm_servicebus_namespace.default.id
#   enable_partitioning = true
# }

### Postgres ###

module "postgres" {
  source              = "./modules/postgres"
  project             = local.project
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
  username            = local.postgres_username
  password            = local.postgres_password
}

### Azure Monitor ###

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${local.project}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "dapr" {
  name                = "appi-${local.project}-dapr"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.default.id
}

### Container Apps - Environment ###

resource "azapi_resource" "managed_environment" {
  name      = "env-${local.project}"
  location  = azurerm_resource_group.default.location
  parent_id = azurerm_resource_group.default.id
  type      = "Microsoft.App/managedEnvironments@2022-03-01"

  body = jsonencode({
    properties = {
      daprAIConnectionString = azurerm_application_insights.dapr.connection_string
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.default.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.default.primary_shared_key
        }
      }
      vnetConfiguration = {
        internal               = false
        runtimeSubnetId        = module.network.runtime_subnet_id
        infrastructureSubnetId = module.network.infrastructure_subnet_id
      }
    }
  })
}

### Datadog Agent ###

module "datadog_agent" {
  source      = "./modules/datadog"
  location    = var.location
  group_id    = azurerm_resource_group.default.id
  environment = azapi_resource.managed_environment.id
  dd_api_key  = var.dd_api_key
}

### Application Apps - Services ###

module "containerapp_documents" {
  source = "./modules/containerapp"

  # Container App
  name        = "app-documents"
  location    = var.location
  group_id    = azurerm_resource_group.default.id
  environment = azapi_resource.managed_environment.id

  # Ingress
  external            = true
  ingress_target_port = 8080

  # Resoruces
  cpu    = 0.5
  memory = "1.0Gi"

  # Container
  container_image = "epomatti/quarkus-datadog-documents"
  container_envs = [
    { name = "QUARKUS_DATASOURCE_USERNAME", value = local.postgres_username },
    { name = "QUARKUS_DATASOURCE_PASSWORD", value = local.postgres_password },
    { name = "QUARKUS_DATASOURCE_JDBC_URL", value = module.postgres.jdbc },
    { name = "DD_SERVICE", value = "documents-service" },
    { name = "DD_ENV", value = "quarkus-azure" },
    { name = "DD_AGENT_HOST", value = module.datadog_agent.fqdn },
    { name = "DD_TRACE_AGENT_URL", value = "http://${module.datadog_agent.fqdn}:8126" },
    { name = "DD_LOGS_INJECTION", value = "true" },
    { name = "DD_TRACE_SAMPLE_RATE", value = "1" },
    { name = "DD_PROFILING_ENABLED", value = "true" },
  ]
}


### Outputs ###

output "postgres_jdbc" {
  value = module.postgres.jdbc
}

output "order_url" {
  value = "https://${module.containerapp_documents.fqdn}"
}
