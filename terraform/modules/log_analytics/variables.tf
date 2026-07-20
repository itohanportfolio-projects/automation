variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "sku" {
  description = "SKU for Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
  validation {
    condition     = contains(["PerGB2018", "Free", "Standard", "Premium"], var.sku)
    error_message = "Log Analytics SKU must be one of: PerGB2018, Free, Standard, or Premium."
  }
}

variable "retention_in_days" {
  description = "Retention period in days"
  type        = number
  default     = 30
  validation {
    condition     = var.retention_in_days >= 0 && var.retention_in_days <= 730
    error_message = "Retention days must be between 0 and 730."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
