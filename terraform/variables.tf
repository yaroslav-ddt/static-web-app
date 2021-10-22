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

#variables used to manage azure cli command
#variable "client_id" {}
#variable "client_secret" {}
#variable "tenant_id" {}