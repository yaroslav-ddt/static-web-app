output "hostname" {
  value = azurerm_static_site.swa.default_host_name
}
output "rg_name" {
  value = azurerm_resource_group.swa_rg.name
}
output "swa_name" {
  value = azurerm_static_site.swa.name
}
output "ai_instrumentation_key" {
  value = azurerm_application_insights.swa_ai.instrumentation_key
  sensitive = true
}