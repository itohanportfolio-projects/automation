resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-${var.project_code}-${var.location}"
  location = var.location

  tags = merge(
    var.common_tags,
    {
      environment = var.environment
      created_at  = timestamp()
    }
  )
}

module "log_analytics" {
  source = "./modules/log_analytics"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  workspace_name      = "log-${var.environment}-${var.project_code}-${var.location}"
  sku                 = "PerGB2018"
  retention_in_days   = local.retention_days

  tags = merge(
    var.common_tags,
    { environment = var.environment }
  )

  depends_on = [azurerm_resource_group.rg]
}

module "app_insights" {
  source = "./modules/app_insights"

  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  app_insights_name        = "appi-${var.environment}-${var.project_code}-${var.location}"
  application_type         = "web"
  retention_in_days        = local.retention_days
  log_analytics_workspace_id = module.log_analytics.workspace_id
  sampling_percentage      = local.sampling_percentage

  tags = merge(
    var.common_tags,
    { environment = var.environment }
  )

  depends_on = [module.log_analytics]
}

module "key_vault" {
  source = "./modules/key_vault"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  key_vault_name      = "kv-${var.environment}-${var.project_code}-${substr(var.location, 0, 3)}"
  sku_name            = local.key_vault_sku
  purge_protection_enabled = var.environment == "prod" ? true : false
  enable_rbac_authorization = true
  
  tags = merge(
    var.common_tags,
    { environment = var.environment }
  )

  depends_on = [azurerm_resource_group.rg]
}

module "app_service" {
  source = "./modules/app_service"

  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  app_service_plan_name = "asp-${var.environment}-${var.project_code}-${var.location}"
  app_service_name      = "app-${var.environment}-${var.project_code}-${substr(var.location, 0, 3)}"
  app_service_sku       = local.app_service_sku
  enable_https_only     = true
  
  app_service_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.app_insights.connection_string
    KeyVaultUri                           = module.key_vault.key_vault_uri
    Environment                           = var.environment
  }

  tags = merge(
    var.common_tags,
    { environment = var.environment }
  )

  depends_on = [module.app_insights, module.key_vault]
}

resource "azurerm_role_assignment" "app_service_keyvault" {
  scope               = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id        = module.app_service.app_service_identity_principal_id
}

resource "azurerm_monitor_diagnostic_setting" "app_service" {
  name                       = "diag-app-service-${var.environment}"
  target_resource_id         = module.app_service.app_service_id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  logs {
    category = "AppServiceHTTPLogs"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  logs {
    category = "AppServiceConsoleLogs"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metrics {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-key-vault-${var.environment}"
  target_resource_id         = module.key_vault.key_vault_id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  logs {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metrics {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

locals {
  app_service_sku = {
    dev      = "B1"
    preprod  = "S1"
    prod     = "P1V2"
  }[var.environment]

  key_vault_sku = {
    dev      = "standard"
    preprod  = "standard"
    prod     = "premium"
  }[var.environment]

  retention_days = {
    dev      = 30
    preprod  = 30
    prod     = 90
  }[var.environment]

  sampling_percentage = {
    dev      = 50
    preprod  = 75
    prod     = 100
  }[var.environment]
}
