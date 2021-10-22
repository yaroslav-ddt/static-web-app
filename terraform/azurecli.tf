#resource "null_resource" "azure-cli" {
#  provisioner "local-exec" {
#    command = <<EOF
#      az login --service-principal -u ${var.client_id} -p ${var.client_secret} --tenant ${var.tenant_id}
#      az staticwebapp appsettings set --name ${azurerm_static_site.swa.name} \
#        --resource-group ${azurerm_resource_group.swa_rg.name} \
#        --subscription ${data.azurerm_client_config.current.subscription_id} \
#        --setting-names APPINSIGHTS_INSTRUMENTATIONKEY=${azurerm_application_insights.swa_ai.instrumentation_key}
#    EOF
#  }
#  depends_on = [azurerm_static_site.swa,azurerm_application_insights.swa_ai]
#}