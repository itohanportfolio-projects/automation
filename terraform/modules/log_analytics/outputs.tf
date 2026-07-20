output "workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name
}

output "customer_id" {
  description = "Customer ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.workspace_id
  sensitive   = true
}

output "primary_shared_key" {
  description = "Primary Shared Key of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  sensitive   = true
}
