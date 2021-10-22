resource "azurerm_application_insights" "swa_ai" {
  name                = "appi-${var.resource_name}"
  location            = azurerm_resource_group.swa_rg.location
  resource_group_name = azurerm_resource_group.swa_rg.name
  application_type    = "web"
}