# Pre-Production Environment Configuration

subscription_id = "xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
environment    = "preprod"
project_code   = "webapp-azure"
location       = "eastus"

common_tags = {
  managed_by  = "Terraform"
  project     = "Web Application"
  environment = "pre-production"
  cost_center = "engineering"
}
