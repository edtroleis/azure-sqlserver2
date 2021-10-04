# Adicionar
# private endpoint
# 

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.79.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

locals {
  tags = {
    "managed"     = "terraformed"
    "owner"       = "me@me.me"
    "environment" = "learning"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "MyDB-RG"
  location = "East US"
  tags     = local.tags
}

resource "azurerm_sql_server" "main" {
  name                         = "mytfqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
  tags                         = local.tags
}

resource "azurerm_sql_firewall_rule" "main" {
  name                = "AlllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

data "azuread_client_config" "current" {}

# resource "azurerm_sql_active_directory_administrator" "example" {
#   server_name         = azurerm_sql_server.main.name
#   resource_group_name = azurerm_resource_group.main.name
#   login               = "sqladmin"
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   object_id           = data.azurerm_client_config.current.object_id
# }

# data "azuread_group" "example" {
#   display_name     = "MyGroupName"
#   security_enabled = true
# }

resource "azuread_group" "adg" {
  display_name     = "example"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azurerm_sql_active_directory_administrator" "adadmin" {
  server_name         = azurerm_sql_server.main.name
  resource_group_name = azurerm_resource_group.main.name
  login               = "sampleadgroup"
  tenant_id           = data.azuread_client_config.current.tenant_id
  object_id           = azuread_group.adg.object_id
}

