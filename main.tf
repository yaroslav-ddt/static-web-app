locals {
  api_token_var = "AZURE_STATIC_WEB_APPS_API_TOKEN"
}

variable "resource_name" {
    default = "staticapp-yy"
}
variable "github_token" {
    default = "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"
}

variable "github_owner" {
    default = "yaroslav-ddt"
}

provider "azurerm" {
  features {}
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "azurerm_resource_group" "test" {
  name     = "rg-${var.resource_name}"
  location = "west europe"
}

resource "azurerm_static_site" "test" {
  name                = "${var.resource_name}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku_tier = "Free" #possible values are "Free" or "Standard"
}

resource "github_repository" "staticwebapp" {
  name         = "static-web-app"
  description  = "terraform codebase"
  auto_init = true
}

resource "github_actions_secret" "api_key" {
  repository      = github_repository.staticwebapp.name
  secret_name     = local.api_token_var
  plaintext_value = azurerm_static_site.test.api_key
}

resource "github_repository_file" "workflow" {
  repository = github_repository.staticwebapp.name
  branch     = "main"
  file       = ".github/workflows/azure-static-web-app.yml"
  overwrite_on_create = true
  content    =  templatefile("./azure-static-web-app.tpl",
     {
       app_location    = "src"
       api_location    = "api"
       output_location = ".github/workflows"
       api_token_var   = local.api_token_var
     }
   )
}

output "hostname" {
  value = azurerm_static_site.test.default_host_name
}
output "staticsite_api_key" {
    value = azurerm_static_site.test.api_key
}
