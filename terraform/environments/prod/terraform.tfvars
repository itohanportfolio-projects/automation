# Production Environment Configuration

subscription_id = "xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
environment    = "prod"
project_code   = "webapp-${var.environment}"
location       = "eastus"

common_tags = {
  managed_by  = "Terraform"
  project     = "Web Application"
  environment = "production"
  cost_center = "operations"
}
