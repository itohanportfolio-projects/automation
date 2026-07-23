terraform {
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-preprod"
    storage_account_name = "stterraformstatepreprod"
    container_name       = "terraform-state"
    key                  = "preprod.terraform.tfstate"
  }
}

module "infrastructure-preprod" {
  source = "../../"

  subscription_id = var.subscription_id
  environment     = var.environment
  project_code    = var.project_code
  location        = var.location
  common_tags     = var.common_tags
}
