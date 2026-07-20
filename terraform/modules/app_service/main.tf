resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_sku

  tags = var.tags
}

resource "azurerm_linux_web_app" "app_service" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  https_only = var.enable_https_only

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
  }

  app_settings = var.app_service_settings

  tags = var.tags

  depends_on = [azurerm_service_plan.app_service_plan]
}
