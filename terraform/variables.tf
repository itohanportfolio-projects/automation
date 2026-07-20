variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, preprod, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "preprod", "prod"], var.environment)
    error_message = "Environment must be one of: dev, preprod, or prod."
  }
}

variable "project_code" {
  description = "Project code for resource naming"
  type        = string
  default     = "webapp"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eunorth"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "Terraform"
    project    = "Web Application"
  }
}
