# Development Environment Configuration

subscription_id = "xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
environment    = "dev"
project_code   = "webapp-${var.environment}"
location       = "eastus"

common_tags = {
  managed_by  = "Terraform"
  project     = "Web Application"
  environment = "development"
  cost_center = "engineering"
}
