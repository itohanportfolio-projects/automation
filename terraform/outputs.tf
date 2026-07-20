output "app_service_name" {
  description = "Name of the App Service"
  value       = module.app_service.app_service_name
}

output "app_service_url" {
  description = "URL of the App Service"
  value       = "https://${module.app_service.app_service_default_hostname}"
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = module.log_analytics.workspace_id
}

output "app_insights_instrumentation_key" {
  description = "Instrumentation Key for Application Insights"
  value       = module.app_insights.instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "Connection String for Application Insights"
  value       = module.app_insights.connection_string
  sensitive   = true
}

output "app_service_principal_id" {
  description = "Principal ID of the App Service Managed Identity"
  value       = module.app_service.app_service_identity_principal_id
}
