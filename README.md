# Opus Azure Data Analysis Terraform scripts

These terraform scripts deploy and configure Azure Data Analysis services for Opus,
including:

- A Azure Data Factory instance
- A bastion VM to manage the Intergration Runtime VM(s)
- A Azure SQL Database instance

## Prerequisites

- Terraform >= 0.11.10
- A service principal which has been created as 'Terraform App' in Portal->Azure Active Directory->App registrations
- Application Id and secret of the service principal 
- Azure Subscription Id
- Azure tenant Id, which is effectively the Azure Active Directory Id

## Configuration

- All varables are defined in vars.tf 
- Either pre-assign values to variables in vars.tf, or assign them on the fly when running the script
- Variable 'env' accpets three values: dev, prod, and test


## Usage

Initialize the working directory containing Terraform configuration files

```
terraform init
```

Do a dry run to check the resources will be provisioned/changed.

```
terraform plan

```

Deploy the resources

```
terraform apply

```

Destroy the resources

```
terraform destroy

```
## State file

'terraform.tfstate' holds the state of the resources that has been deployed. It should be carefully preserverd, please refer to https://www.terraform.io/docs/state/ for more information

