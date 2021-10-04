variable "diagsettings_log" {
  type = map(any)
  default = {
    "Errors"                      = true
    "SQLInsights"                 = false
    "AutomaticTuning"             = false
    "QueryStoreRuntimeStatistics" = false
    "QueryStoreWaitStatistics"    = false
    "DatabaseWaitStatistics"      = false
    "Timeouts"                    = false
    "Blocks"                      = false
    "Deadlocks"                   = false
    "DevOpsOperationsAudit"       = false
    "SQLSecurityAuditEvents"      = false
  }
}

variable "diagsettings_metric" {
  type = map(any)
  default = {
    "Basic"                  = true
    "InstanceAndAppAdvanced" = false
    "WorkloadManagement"     = false

  }
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  count                      = length(var.databases)
  name                       = azurerm_sql_database.main[count.index].name
  target_resource_id         = azurerm_sql_database.main[count.index].id
  storage_account_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

  dynamic "log" {
    for_each = var.diagsettings_log
    content {
      category = log.key
      enabled  = log.value

      retention_policy {
        days    = log.value == true ? 30 : 0
        enabled = log.value
      }
    }

  }

  dynamic "metric" {
    for_each = var.diagsettings_metric
    content {
      category = metric.key
      enabled  = metric.value

      retention_policy {
        days    = metric.value == true ? 30 : 0
        enabled = metric.value
      }
    }
  }
}
