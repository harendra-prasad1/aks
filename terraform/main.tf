data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

module "resource_group" {
  source      = "./modules/resource-groups"
  name_prefix = var.name_prefix
  location    = var.location
}

module "vnet" {
  source              = "./modules/virtual-network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = "${var.name_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
}

module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
}

module "aks" {
  source                 = "./modules/aks"
  location               = module.resource_group.location
  resource_group_name    = module.resource_group.name
  cluster_name           = var.cluster_name
  sku_tier               = var.sku_tier
  kubernetes_version     = data.azurerm_kubernetes_service_versions.current.latest_version
  system_node_vm_size    = var.system_node_vm_size
  user_node_vm_size      = var.user_node_vm_size
  acr_id                 = module.acr.acr_id
}