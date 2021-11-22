terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  
  subscription_id = "e5b88ba1-6e66-4465-9fe2-2d59087de303"
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

#data source to access the configuration of the AzureRM provider
data "azurerm_client_config" "current" {}



