variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "B1"
  validation {
    condition     = contains(["F1", "B1", "B2", "B3", "S1", "S2", "S3", "P1V2", "P2V2", "P3V2"], var.app_service_sku)
    error_message = "App Service SKU must be a valid tier."
  }
}

variable "enable_https_only" {
  description = "Enable HTTPS only"
  type        = bool
  default     = true
}

variable "app_service_settings" {
  description = "Additional app settings for the App Service"
  type        = map(string)
  default     = {}
}

variable "app_service_slot_enabled" {
  description = "Whether to create a staging deployment slot for the App Service"
  type        = bool
  default     = true
}

variable "app_service_slot_name" {
  description = "Name of the App Service deployment slot"
  type        = string
  default     = "staging"
}

variable "app_service_slot_settings" {
  description = "App settings for the staging deployment slot"
  type        = map(string)
  default     = {
    NODE_ENV = "production"
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
