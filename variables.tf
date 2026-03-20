variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "ganzo-golf-rg"
}

variable "app_name" {
  description = "App Service name — must be globally unique in Azure"
  type        = string
  default     = "ganzo-golf-app"
}

variable "db_server_name" {
  description = "PostgreSQL Flexible Server name — must be globally unique in Azure"
  type        = string
  default     = "ganzo-golf-db"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "ganzogolf"
}

variable "db_admin_username" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "ganzoadmin"
}

variable "db_admin_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "openai_api_key" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
}

variable "google_places_api_key" {
  description = "Google Places API key"
  type        = string
  sensitive   = true
}
