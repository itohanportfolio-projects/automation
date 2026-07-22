resource "azurerm_key_vault" "key_vault" {
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  sku_name                        = var.sku_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id

  tags = var.tags
}

data "azurerm_client_config" "current" {}
