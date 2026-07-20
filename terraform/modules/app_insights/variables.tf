variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "app_insights_name" {
  description = "Name of the Application Insights"
  type        = string
}

variable "application_type" {
  description = "Application type for App Insights"
  type        = string
  default     = "web"
  validation {
    condition     = contains(["web", "java", "MobileCenter", "other"], var.application_type)
    error_message = "Application type must be one of: web, java, MobileCenter, or other."
  }
}

variable "retention_in_days" {
  description = "Retention period in days"
  type        = number
  default     = 30
  validation {
    condition     = contains([30, 60, 90, 120, 180, 365, 550, 730], var.retention_in_days)
    error_message = "Retention days must be one of: 30, 60, 90, 120, 180, 365, 550, or 730."
  }
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  type        = string
}

variable "sampling_percentage" {
  description = "Sampling percentage"
  type        = number
  default     = 100
  validation {
    condition     = var.sampling_percentage >= 0 && var.sampling_percentage <= 100
    error_message = "Sampling percentage must be between 0 and 100."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
