terraform {
 
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-dev"
    storage_account_name = "webappazuredev"
    container_name       = "terraform-state"
    key                  = "dev.terraform.tfstate"
  }
}

module "webapp_dev" {
  source = "../../"

  subscription_id = var.subscription_id
  environment     = var.environment
  project_code    = var.project_code
  location        = var.location
  common_tags     = var.common_tags
}
