terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.26.0" # Replace with the latest version if needed
    }
    // add azure entraid provider
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.1.0" # Replace with the latest version if needed
    }

  }
}

provider "azurerm" {
  features {}
  subscription_id     = var.subscription_id
  storage_use_azuread = true
}