# Azure Web Application Infrastructure with Terraform

This repository contains a modular, production-ready Terraform configuration for deploying a complete web application infrastructure on Azure across three environments: Development (Dev), Pre-Production (Pre-Prod), and Production (Prod).

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [Resources Managed](#resources-managed)
- [Module Details](#module-details)
- [Deployment Guide](#deployment-guide)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This Terraform project provides:

✅ **Modular Architecture** - Reusable modules for each Azure resource
✅ **Multi-Environment Support** - Easy management across Dev, Pre-Prod, and Prod
✅ **Environment-Specific Configurations** - Different SKUs, retention policies, and settings per environment
✅ **Best Practices** - Follows Azure and Terraform best practices
✅ **Security** - RBAC, HTTPS enforcement, Key Vault integration
✅ **Monitoring** - Application Insights with Log Analytics integration

---

## 📁 Project Structure

```
azure-terraform/
├── .azure/
│   └── deployment-plan.md          # Deployment planning document
├── terraform/
│   ├── modules/                    # Reusable Terraform modules
│   │   ├── app_service/           # App Service module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── key_vault/             # Key Vault module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── log_analytics/         # Log Analytics module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── app_insights/          # Application Insights module
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   ├── environments/              # Environment-specific configurations
│   │   ├── dev/
│   │   │   ├── terraform.tfvars  # Dev variables
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── preprod/
│   │   │   ├── terraform.tfvars  # Pre-Prod variables
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── prod/
│   │       ├── terraform.tfvars  # Prod variables
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   ├── provider.tf               # Azure provider configuration
│   ├── main.tf                   # Root module resources
│   ├── variables.tf              # Global variable definitions
│   └── outputs.tf                # Global outputs
├── README.md                      # This file
└── .gitignore                     # Git ignore file
```

---

## 📋 Prerequisites

### Required Tools

- **Terraform** >= 1.0 - [Install](https://www.terraform.io/downloads)
- **Azure CLI** - [Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **An Azure Subscription** - [Create one](https://azure.microsoft.com/free/)

### Azure Permissions

You need the following Azure RBAC roles:
- `Owner` or `Contributor` role on the subscription/resource group
- Ability to create and manage:
  - Resource Groups
  - App Service Plans
  - App Services
  - Key Vaults
  - Log Analytics Workspaces
  - Application Insights

### Setup Azure CLI

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify your account
az account show
```

---

## 🚀 Getting Started

### 1. Clone or Download the Repository

```bash
cd c:\Azure-terraform
```

### 2. Update Environment Variables

Edit the tfvars file for your target environment:

**For Dev:**
```bash
# Edit terraform/environments/dev/terraform.tfvars
subscription_id = "YOUR_ACTUAL_SUBSCRIPTION_ID"
```

**For Pre-Prod:**
```bash
# Edit terraform/environments/preprod/terraform.tfvars
subscription_id = "YOUR_ACTUAL_SUBSCRIPTION_ID"
```

**For Prod:**
```bash
# Edit terraform/environments/prod/terraform.tfvars
subscription_id = "YOUR_ACTUAL_SUBSCRIPTION_ID"
```

### 3. Initialize Terraform

For Development:
```bash
cd terraform/environments/dev
terraform init
```

For Pre-Production:
```bash
cd terraform/environments/preprod
terraform init
```

For Production:
```bash
cd terraform/environments/prod
terraform init
```

### 4. Validate Configuration

```bash
terraform validate
```

### 5. Plan Deployment

```bash
terraform plan -out=tfplan
```

### 6. Apply Configuration

```bash
terraform apply tfplan
```

---

## 🔧 Environment Configuration

### Naming Convention

The infrastructure uses a consistent naming convention:

```
{resource-type}-{environment}-{project-code}-{region-abbr}
```

Examples:
- Dev: `app-dev-webapp-eas` (App Service in Dev, Eastern US)
- Pre-Prod: `kv-preprod-webapp-eas` (Key Vault in Pre-Prod)
- Prod: `appi-prod-webapp-eas` (Application Insights in Prod)

### Environment-Specific Settings

| Setting | Dev | Pre-Prod | Prod |
|---------|-----|----------|------|
| **App Service SKU** | B1 (Shared) | S1 (Standard) | P1V2 (Premium) |
| **Key Vault SKU** | Standard | Standard | Premium |
| **Log Retention** | 7 days | 30 days | 90 days |
| **App Insights Sampling** | 50% | 75% | 100% |
| **Purge Protection** | Disabled | Disabled | Enabled |

### Modify Environment Settings

Edit the environment-specific `terraform.tfvars`:

```hcl
# Example: Change location
location = "westeurope"

# Example: Modify tags
common_tags = {
  managed_by  = "Terraform"
  environment = "development"
  cost_center = "engineering"
}
```

---

## 📦 Resources Managed

### 1. **App Service** (Linux Web App)
- **Tier Levels**: Free (F1) → Basic (B1-B3) → Standard (S1-S3) → Premium (P1V2-P3V2)
- **Configuration**: HTTPS enforcement, TLS 1.2 minimum
- **Scaling**: Horizontal scaling based on plan tier
- **Managed Identity**: System-assigned identity enabled

### 2. **Azure Key Vault**
- **Purpose**: Secrets and credentials storage
- **Access**: RBAC-based authorization
- **Security**: Soft delete and purge protection enabled
- **SKU**: Standard (Dev/Pre-Prod) → Premium (Prod)

### 3. **Log Analytics Workspace**
- **Purpose**: Centralized log aggregation
- **Retention**: 7 days (Dev) → 90 days (Prod)
- **Workspace ID**: Exported for Log Ingestion API

### 4. **Application Insights**
- **Application Type**: Web
- **Sampling**: Environment-specific sampling rates
- **Integration**: Connected to Log Analytics Workspace
- **Outputs**: Instrumentation Key & Connection String

---

## 🔧 Module Details

### App Service Module (`modules/app_service/`)

**Purpose**: Manages Azure App Service and App Service Plan

**Key Inputs**:
- `app_service_sku` - Plan tier
- `app_service_settings` - Environment variables
- `enable_https_only` - HTTPS enforcement

**Key Outputs**:
- `app_service_name` - App Service name
- `app_service_default_hostname` - Default domain
- `app_service_identity_principal_id` - Managed Identity ID

---

### Key Vault Module (`modules/key_vault/`)

**Purpose**: Manages Azure Key Vault for secrets storage

**Key Inputs**:
- `sku_name` - Standard or Premium
- `purge_protection_enabled` - Purge protection state
- `enable_rbac_authorization` - RBAC mode

**Key Outputs**:
- `key_vault_uri` - Vault URL
- `tenant_id` - Entra ID tenant ID

---

### Log Analytics Module (`modules/log_analytics/`)

**Purpose**: Manages Log Analytics Workspace for centralized logging

**Key Inputs**:
- `sku` - Pricing tier
- `retention_in_days` - Log retention period

**Key Outputs**:
- `workspace_id` - Workspace ID
- `customer_id` - Log Ingestion API ID

---

### Application Insights Module (`modules/app_insights/`)

**Purpose**: Manages Application Insights for application monitoring

**Key Inputs**:
- `application_type` - App type (web, java, other)
- `sampling_percentage` - Telemetry sampling rate
- `log_analytics_workspace_id` - Linked workspace

**Key Outputs**:
- `instrumentation_key` - App Insights key
- `connection_string` - Connection string for SDKs

---

## 📊 Deployment Guide

### Step-by-Step Deployment

#### Option 1: Deploy to Dev Environment

```bash
# Navigate to dev environment
cd terraform/environments/dev

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

#### Option 2: Deploy to Pre-Prod Environment

```bash
cd terraform/environments/preprod
terraform init
terraform validate
terraform plan
terraform apply
```

#### Option 3: Deploy to Prod Environment

```bash
cd terraform/environments/prod
terraform init
terraform validate
terraform plan
terraform apply
```

### View Deployment Outputs

```bash
# View outputs from current environment
terraform output

# View specific output (e.g., App Service URL)
terraform output app_service_url

# View sensitive outputs
terraform output -json app_insights_instrumentation_key
```

### Destroy Resources

```bash
# Destroy all resources in an environment
terraform destroy

# Confirm when prompted
```

---

## ✅ Best Practices

### 1. **State Management**

For production use, configure remote state:

```hcl
# terraform/environments/prod/main.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-prod"
    storage_account_name = "stterraformstateprod"
    container_name       = "terraform-state"
    key                  = "prod.terraform.tfstate"
  }
}
```

### 2. **Version Control**

```bash
# .gitignore
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
terraform.tfvars.local
```

### 3. **Naming Conventions**

- Use lowercase letters and hyphens for names
- Keep names descriptive but concise
- Include environment indicator (dev, preprod, prod)
- Follow Azure naming limits (3-63 characters for many resources)

### 4. **Tagging Strategy**

```hcl
common_tags = {
  environment = "production"
  cost_center = "operations"
  managed_by  = "Terraform"
  project     = "Web Application"
  created_at  = timestamp()
}
```

### 5. **Security**

- ✅ HTTPS enforcement enabled
- ✅ TLS 1.2 minimum
- ✅ RBAC authorization for Key Vault
- ✅ Managed Identity for App Service
- ✅ Purge protection in Prod
- ✅ Secrets marked as sensitive in outputs

### 6. **Monitoring**

- Application Insights connected to Log Analytics
- Environment-specific retention policies
- Sampling rates optimized per environment
- Key outputs exported for dashboards

---

## 🐛 Troubleshooting

### Error: "Azure CLI is not installed"

```bash
# Install Azure CLI
# macOS:
brew install azure-cli

# Windows (PowerShell):
winget install Microsoft.AzureCLI

# Verify installation
az --version
```

### Error: "Subscription not found"

```bash
# List your subscriptions
az account list --output table

# Set correct subscription ID in terraform.tfvars
subscription_id = "YOUR_CORRECT_SUBSCRIPTION_ID"
```

### Error: "Key Vault name already exists"

Key Vault names are globally unique. Modify your naming:

```hcl
# In terraform/main.tf, update the Key Vault name
key_vault_name = "kv-${var.environment}-${var.project_code}-${substr(var.location, 0, 3)}-${formatdate("MMdd", timestamp())}"
```

### Error: "Insufficient permissions"

Ensure your Azure account has:
- Subscription-level `Contributor` role
- Permissions to create resource groups
- Permissions to manage identity and access

```bash
# Check your current role
az role assignment list --output table
```

### State Not Found After Init

```bash
# Reuse existing state (if not destroyed)
terraform init

# Force reinit
terraform init -upgrade
```

### Resource Already Exists

If resources already exist in Azure:

```bash
# Import existing resource
terraform import module.app_service.azurerm_linux_web_app.app_service /subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Web/sites/{appServiceName}
```

---

## 📚 Additional Resources

### Azure Documentation
- [Azure App Service](https://docs.microsoft.com/azure/app-service/)
- [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/)
- [Log Analytics](https://docs.microsoft.com/azure/azure-monitor/logs/data-platform-logs)
- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)

### Terraform Documentation
- [Terraform on Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Terraform Best Practices](https://www.terraform.io/language/style)
- [State Management](https://www.terraform.io/language/state)

### Azure CLI Documentation
- [Azure CLI Reference](https://docs.microsoft.com/cli/azure/reference-index)
- [Azure CLI Install](https://docs.microsoft.com/cli/azure/install-azure-cli)

---

## 📝 Notes

### Key Vault Naming

Azure Key Vault names are globally unique and must be 3-24 characters. If you encounter a naming conflict, modify the naming pattern in `terraform/main.tf`:

```hcl
key_vault_name = "kv-${var.environment}-${var.project_code}-${substr(var.location, 0, 3)}"
```

### Cost Considerations

Different environments have different resource tiers:
- **Dev**: Low cost, suitable for testing
- **Pre-Prod**: Medium cost, mirrors production
- **Prod**: Higher cost, optimized for performance and reliability

Monitor your Azure costs regularly using:
```bash
az costmanagement query --timeframe ActualLastMonth
```

---

## 🤝 Support

For issues or questions:

1. Check the [troubleshooting section](#troubleshooting)
2. Review [Azure documentation](https://docs.microsoft.com/azure/)
3. Check [Terraform Registry](https://registry.terraform.io/)
4. Consult [Azure CLI reference](https://docs.microsoft.com/cli/azure/)

---

## ⚖️ License

This Terraform configuration is provided as-is for educational and production use.

---

## ✨ Highlights

This infrastructure provides:

- 🏗️ **Production-Ready**: Follows Azure and Terraform best practices
- 🔄 **Reusable**: Modular design for easy extensibility
- 🌍 **Multi-Environment**: Dev, Pre-Prod, and Prod configurations
- 🔐 **Secure**: RBAC, HTTPS, encryption, and secrets management
- 📊 **Observable**: Full monitoring with Application Insights and Log Analytics
- 📝 **Well-Documented**: Comprehensive code comments and documentation
- 🎯 **Cost-Optimized**: Different SKUs and settings per environment

---

**Last Updated**: $(date)
