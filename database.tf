# faz sentido ser um módulo?
variable "databases" {
  type    = list(string)
  default = ["database1", "database2"]
}

resource "azurerm_sql_database" "main" {
  count                            = length(var.databases)
  name                             = element(var.databases, count.index)
  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  server_name                      = azurerm_sql_server.main.name
  edition                          = "Standard" # Basic, Standard, Premium, DataWarehouse, Business, BusinessCritical, Free, GeneralPurpose, Hyperscale, Premium, PremiumRS, Standard, Stretch, System, System2, or Web
  create_mode = "Default" # Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup
  # max_size_bytes
  requested_service_objective_name = "S1" #S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool # az sql db list-editions -l brazilsouth -o table
  collation = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  tags                             = local.tags
}

# resource "azurerm_mssql_elasticpool" "elastic_pool" {
#   count = var.enable_elasticpool ? 1 : 0
#   name  = local.elastic_pool_name

#   location            = var.location
#   resource_group_name = var.resource_group_name

#   server_name = azurerm_sql_server.server.name

#   per_database_settings {
#     max_capacity = coalesce(var.database_max_capacity, var.sku.capacity)
#     min_capacity = var.database_min_capacity
#   }

#   max_size_gb    = var.elastic_pool_max_size
#   zone_redundant = var.zone_redundant

#   sku {
#     capacity = local.elastic_pool_sku.capacity
#     name     = local.elastic_pool_sku.name
#     tier     = local.elastic_pool_sku.tier
#     family   = local.elastic_pool_sku.family
#   }

#   tags = merge(local.default_tags, var.extra_tags, var.server_extra_tags)
# }