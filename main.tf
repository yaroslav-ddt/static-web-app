locals {
  api_token_var = "AZURE_STATIC_WEB_APPS_API_TOKEN"
}

variable "resource_name" {
    default = "staticapp-yy"
}
variable "github_token" {}

variable "github_owner" {}

variable "repository_name" {
    default = "static-web-app"
}

# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}

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
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "azurerm_resource_group" "swa_rg" {
  name     = "rg-${var.resource_name}"
  location = "west europe"
}

resource "azurerm_application_insights" "swa_ai" {
  name                = "appi-${var.resource_name}"
  location            = azurerm_resource_group.swa_rg.location
  resource_group_name = azurerm_resource_group.swa_rg.name
  application_type    = "web"
}
resource "azurerm_static_site" "swa" {
  name                = "${var.resource_name}"
  location            = azurerm_resource_group.swa_rg.location
  resource_group_name = azurerm_resource_group.swa_rg.name
  sku_tier = "Free" #possible values are "Free" or "Standard"
  tags                = {
    "owner" = "yy"
  }
}

#resource "github_repository" "swa_github" {
#  name         = "static-web-app"
#  description  = "terraform codebase"
#  auto_init = true
#}

# resource "null_resource" "azure-cli" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az login --service-principal -u ${var.client_id} -p ${var.client_secret} --tenant ${var.tenant_id}
#       az staticwebapp appsettings set --name ${azurerm_static_site.swa.name} --setting-names APPINSIGHTS_INSTRUMENTATIONKEY=${azurerm_application_insights.swa_ai.instrumentation_key}"
#     EOT
#   }
#   depends_on = [azurerm_static_site.swa,azurerm_application_insights.swa_ai]
# }

#adding api key to the github secrets
resource "github_actions_secret" "api_key" {
  repository      = var.repository_name #github_repository.swa_github.name
  secret_name     = local.api_token_var
  plaintext_value = azurerm_static_site.swa.api_key
}

#creating workflow file from template
resource "github_repository_file" "workflow" {
  repository =  var.repository_name #github_repository.swa_github.name
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
  value = azurerm_static_site.swa.default_host_name
}
#output "staticsite_api_key" {
#  value = azurerm_static_site.swa.api_key
#}
output "swa_name" {
  value = azurerm_static_site.swa.name
}
output "ai_instrumentation_key" {
  value = azurerm_application_insights.swa_ai.instrumentation_key
  sensitive = true
}