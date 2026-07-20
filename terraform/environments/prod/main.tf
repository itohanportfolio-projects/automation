terraform {
  # State backend configuration for production
  # Uncomment and configure to use remote state
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-prod"
    storage_account_name = "stterraformstateprod"
    container_name       = "terraform-state"
    key                  = "prod.terraform.tfstate"
  }
}

module "infrastructure-prod" {
  source = "../../"

  subscription_id = var.subscription_id
  environment     = var.environment
  project_code    = var.project_code
  location        = var.location
  common_tags     = var.common_tags
}
