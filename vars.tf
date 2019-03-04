variable "subscription_id" {
  description = "Enter Subscription ID for prpvisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID or Directory ID of your Azure AD"
}

variable "location" {
  description = "The default Azure region for the resource provisioning"
}

variable "env_name" {
  description = "Environment name for different resources"
}

variable "vnet_cidr" {
  description = "CIDR block for virtual network"
}

variable "subnet1_cidr" {
  description = "CIDRK block for subnet 1"
}

variable "subnet2_cidr" {
  description = "CIDR block for subnet 2"
}

variable "IR_ip" {
  description = "Private IP address for IR instance"
}

variable "admin_username_bastion" {
  description = "Admin user name for the bastion VM"
}

variable "admin_password_bastion" {
  description = "Admin password for the bastion VM"
}

variable "admin_username_IR" {
  description = "Admin user name for the IR VM"
}

variable "admin_password_IR" {
  description = "Admin password for the IR VM"
}

variable "ADFLocation" {
  description = "Azure Data Factory Region name: Australia East or Southeast Asia"
  default     = "Southeast Asia"
}

variable "sqladmin" {
  description = "Azure SQL Database admin username"
}

variable "sqladminpassword" {
  description = "Azure SQL Database admin password"
}
