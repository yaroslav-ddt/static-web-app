resource "azurerm_static_site" "swa" {
  name                = "${var.resource_name}"
  location            = azurerm_resource_group.swa_rg.location
  resource_group_name = azurerm_resource_group.swa_rg.name
  sku_tier = "Standard" #possible values are "Free" or "Standard"
  tags                = {
    "owner" = "yy"
  }
}
