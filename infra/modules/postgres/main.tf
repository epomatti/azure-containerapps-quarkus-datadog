terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.30.0"
    }
  }
}

### Variables ###

variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

### Postgres ###

resource "azurerm_postgresql_flexible_server" "default" {
  name                         = "psql-${var.project}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "14"
  administrator_login          = var.username
  administrator_password       = var.password
  storage_mb                   = 32768
  sku_name                     = "B_Standard_B1ms"
  geo_redundant_backup_enabled = false
  zone                         = 1
}

### Output ###

output "fqdn" {
  value = azurerm_postgresql_flexible_server.default.fqdn
}
