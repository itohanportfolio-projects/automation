# Terraform and App Service Pipeline Design

# Updated: July 2026
# CreatedBy: Itohan Eregie
## Overview

This repository implements an automated Azure platform deployment solution using Terraform for infrastructure provisioning and Azure DevOps YAML pipelines for continuous delivery.

The solution consists of two independent delivery paths:
1. Terraform - Consisting of azure resource definition 
2. Pipeline - Infrasturture and Web application provisioning

The platform supports three isolated environments:

- Development
- Pre-Production
- Production

The design follows Infrastructure as Code (IaC) best practices by ensuring infrastructure is version controlled, repeatable, and promoted through controlled deployment stages.
---
# Infrastructure Design Choices
## Terraform Module Design Pattern
The Terraform implementation follows a reusable module-based architecture.
The code is separated into:
            terraform/

            ├── environments/
            │
            ├── dev/
            ├── preprod/
            └── prod/

            └── modules/

            ├── app_service/
            ├── key_vault/
            ├── app_insights/
            └── log_analytics/

## Why Terraform Modules Were Used

Terraform modules provide a reusable abstraction layer for Azure resources.

Instead of maintaining separate Terraform resource definitions for Dev, PreProd, and Prod, common infrastructure logic is implemented once and consumed by each environment.

For example:

The App Service module manages:

- App Service Plan creation
- App Service configuration
- HTTPS enforcement
- Managed Identity configuration
- Application settings

The Key Vault module manages:

- Vault creation
- RBAC configuration
- Security settings

The monitoring modules manage:

- Application Insights
- Log Analytics Workspace

Benefits of this design:

- Reduces infrastructure duplication
- Ensures consistent security controls across environments
- Prevents configuration drift
- Simplifies maintenance and upgrades
- Allows environment-specific customisation through variables
---
# Environment Separation Strategy
Each environment has its own Terraform configuration and state.
The environments are logically isolated:
            Development

            |
            |

            PreProduction

            |
            |

            Production    

Each environment maintains independent:
- Terraform configuration
- Terraform state
- Resource configuration
- Deployment lifecycle

This prevents changes in one environment affecting another.

Example:

A production deployment cannot accidentally modify development resources because:

- Different Terraform state
- Different backend configuration
- Different resource groups
- Different Azure DevOps deployment environment
---
# Terraform Remote State Management
Terraform state is stored remotely using an Azure Storage Account backend.
Terraform state is not stored locally or committed to source control.
Each environment has a separate state file


## Benefits of Separate State Files

Environment-specific state separation provides:

- Isolation between environments
- Reduced blast radius
- Independent lifecycle management
- Improved security boundaries
- Easier rollback and recovery

Terraform state locking is enabled through Azure Storage blob locking to prevent simultaneous modifications.
---
# Environment Configuration Management
Environment-specific settings are managed through Terraform variables and locals.

# Security Design Choices
Managed Identity
- App Service uses a System Assigned Managed Identity.
- This removes the requirement to store Azure credentials in:
    - Application configuration
    - Pipeline variables
    - Source control

The identity is granted access through Azure RBAC.
# Key Vault RBAC Authorization
The Key Vault implementation uses:
- enable_rbac_authorization = true
The App Service identity receives:
- role_definition_name = "Key Vault Secrets User"

This approach was selected instead of legacy Key Vault access policies.
# Benefits:
1. Centralised Azure IAM management
2. Least privilege access
3. Better auditing
4. Integration with Azure governance controls
5. Support for Privileged Identity Management (PIM)
6. Monitoring and Observability

The infrastructure provisions:
Application Insights
Log Analytics Workspace

Application Insights uses a workspace-based configuration:

log_analytics_workspace_id =
module.log_analytics.workspace_id

# The App Service receives:

APPLICATIONINSIGHTS_CONNECTION_STRING

This enables monitoring of:

Application requests
Exceptions
Performance metrics
Dependency calls

# Log Analytics provides centralised storage for:

Application logs
Platform diagnostics
Operational troubleshooting
KQL-based analysis
Terraform Pipeline Design

# The Terraform Azure DevOps pipeline automates infrastructure deployment.

The pipeline contains two main stages:

Validate

    |

Deploy
Terraform Validate Stage
The validation stage performs:

- Terraform installation
- Terraform initialization
- Terraform validation
- Terraform plan generation

Example operations:

terraform init

terraform validate

terraform plan

The generated Terraform plan is published as an artifact.
This ensures the exact reviewed plan is applied during deployment.
Terraform Deployment Strategy

Infrastructure deployment follows an environment promotion model:

Development

      |

PreProduction

      |

Production

Azure DevOps environments provide approval gates.

Controls:

Dev deployment: automatic
PreProduction deployment: approval required
Production deployment: approval required

This provides controlled infrastructure changes and separation of duties.
# Application Deployment Pipeline Design

The application pipeline is responsible only for application lifecycle management.

It performs:

Application build
Automated testing
Packaging
Deployment

The pipeline flow:

Build

 |

Test

 |

Package

 |

Deploy Dev

 |

Deploy PreProd

 |

Deploy Production Slot

 |

Swap
Application Artifact Strategy

The pipeline creates an immutable application artifact:

app.zip

The same artifact is promoted through environments.

Benefits:
- Consistent releases
- Traceability
- Reduced deployment differences between environments
- Application Configuration and Secrets

Environment-specific configuration is managed using Azure DevOps variable groups.

Examples:
app-service-dev
app-service-preprod
app-service-prod
Secrets are not stored directly in YAML.

Application settings use Key Vault references:

@Microsoft.KeyVault(SecretUri=<secret-uri>)

The App Service retrieves secrets securely using Managed Identity.
Production Deployment Strategy
Production deployments use App Service deployment slots.

# The release process:

- Deploy application to staging slot
- Execute smoke tests
- Validate application availability
- Swap staging slot into production

Benefits:

- Reduced downtime
- Safer production releases
- Ability to validate before customer traffic migration
- Simplified rollback
- Pipeline and Infrastructure Responsibility Separation

The design separates responsibilities between pipelines.

# Terraform Pipeline Responsibilities

Terraform manages:
Azure resources
App Service creation
Managed Identity
Key Vault
RBAC assignments
Monitoring resources
Application Pipeline Responsibilities

# Application pipeline manages:

Application packaging
Testing
Deployment
Application configuration

This prevents application deployments from modifying infrastructure security boundaries.

# Assumptions
Azure DevOps
- Azure DevOps is used as the CI/CD platform.
- A service connection exists:
    - AzureServiceConnection

The service connection is assumed to use secure authentication.

Recommended:

Workload Identity Federation
instead of long-lived client secrets.
Variable Groups
Environment-specific variable groups are configured:
- app-service-dev
- app-service-preprod
- app-service-prod

Variables include:

Application names
Resource groups
Key Vault references
Secret URIs

Example:

appNameDev
appNamePreprod
appNameProd
resourceGroupDev
resourceGroupPreprod
resourceGroupProd

# Application Assumptions

The sample application:

Is a Node.js application
Uses Node.js version 18
Exists under:
example-voting-app-main/result

The pipeline executes:
- npm ci
- npm test