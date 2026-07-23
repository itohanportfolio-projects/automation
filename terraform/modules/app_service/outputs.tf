output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_linux_web_app.app_service.id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.app_service.name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.app_service.default_hostname
}

output "app_service_identity_principal_id" {
  description = "Principal ID of the App Service managed identity"
  value       = azurerm_linux_web_app.app_service.identity[0].principal_id
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.app_service_plan.id
}

output "app_service_slot_id" {
  description = "ID of the staging deployment slot"
  value       = length(azurerm_linux_web_app_slot.staging) > 0 ? azurerm_linux_web_app_slot.staging[0].id : null
}

output "app_service_slot_name" {
  description = "Name of the staging deployment slot"
  value       = length(azurerm_linux_web_app_slot.staging) > 0 ? azurerm_linux_web_app_slot.staging[0].name : null
}

output "app_service_slot_default_hostname" {
  description = "Default hostname of the staging deployment slot"
  value       = length(azurerm_linux_web_app_slot.staging) > 0 ? azurerm_linux_web_app_slot.staging[0].default_hostname : null
}
