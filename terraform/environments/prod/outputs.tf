output "app_service_name" {
  description = "Name of the App Service"
  value       = module.webapp_prod.app_service_name
}

output "app_service_url" {
  description = "URL of the App Service"
  value       = module.webapp_prod.app_service_url
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.webapp_prod.key_vault_uri
}

output "app_insights_instrumentation_key" {
  description = "Instrumentation Key for Application Insights"
  value       = module.webapp_prod.app_insights_instrumentation_key
  sensitive   = true
}
