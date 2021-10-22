resource "azurerm_resource_group" "swa_rg" {
  name     = "rg-${var.resource_name}"
  location = "west europe"
}