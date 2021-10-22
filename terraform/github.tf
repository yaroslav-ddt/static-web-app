#resource "github_repository" "swa_github" {
#  name         = "static-web-app"
#  description  = "terraform codebase"
#  auto_init = true
#}

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