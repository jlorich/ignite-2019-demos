terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version = "=1.36.0"
}

resource "azurerm_resource_group" "default" {
  name     = "${var.prefix}-${var.name}-${var.environment}-rg"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "default" {
  name                = "${var.name}-plan"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  kind                = "Linux"

  # Reserved must be set to true for Linux App Service Plans
  reserved = true

  sku {
    tier = "standard"
    size = "s1"
  }
}

resource "azurerm_app_service" "default" {
  name                = "${var.prefix}-${var.name}-${var.environment}-app"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|nginxdemos/hello"
  }
}


output "app_name" {
  value = "${azurerm_app_service.default.name}"
}