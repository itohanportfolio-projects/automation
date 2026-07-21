# Terraform and App Service Pipeline Design

## Overview
This repository contains two main delivery paths:
- `terraform/`: Azure infrastructure provisioning for App Service, Key Vault, Log Analytics, and monitoring
- `pipeline/`: Azure DevOps YAML pipelines for Terraform deployment and sample app deployment to App Service

## Infrastructure Design Choices
- **Managed Identity for App Service**: App Service uses `SystemAssigned` managed identity so it can securely access Azure resources without storing credentials.
- **Key Vault RBAC enabled**: Key Vault is configured with RBAC authorization and App Service is granted the `Key Vault Secrets User` role. This avoids legacy access policies and aligns with modern least-privilege security.
- **Diagnostics**: Root `main.tf` includes diagnostic settings for App Service and Key Vault to send logs and metrics to Log Analytics, improving observability and auditability.
- **TLS 1.2 enforcement**: App Service enforces `minimum_tls_version = "1.2"` to ensure secure client connections.
- **No instrumentation key in app settings**: The infrastructure still creates Application Insights, but the old `APPINSIGHTS_INSTRUMENTATION_KEY` secret is removed from the app settings to reduce secret exposure.

## Pipeline Design Choices
- **Terraform pipeline**: separate validation and deploy stages with plan artifacts and environment-based deployments, including approval gates for PreProd and Prod.
- **App Service pipeline**: builds the Node.js sample app, packages it, and deploys it to Dev/PreProd/Prod.
- **Secure app settings**: application settings and secrets are managed via Azure Key Vault and pipeline variable groups, instead of inline secrets in YAML.
- **Safe Prod deployment**: production uses a staging deployment slot, smoke tests the staging slot, and swaps it into production only after verification.

## Assumptions
- Azure DevOps is used as the CI/CD platform.
- An Azure service connection named `AzureServiceConnection` exists for deployment.
- Variable groups are configured for each environment with values such as:
  - `appNameDev`, `appNamePreprod`, `appNameProd`
  - `resourceGroupDev`, `resourceGroupPreprod`, `resourceGroupProd`
  - `keyVaultDev`, `keyVaultPreprod`, `keyVaultProd`
  - `DbConnectionStringSecretUri`, `ApiKeySecretUri`
- App Service is configured to use Key Vault references in app settings via managed identity.
- The sample app is a Node.js application located in `example-voting-app-main/result`.
- The pipeline runs on `ubuntu-latest` build agents and uses Node.js 18.
