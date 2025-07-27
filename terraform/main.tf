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


module "aks" {
  source      = "./modules/aks"
  location    = module.resource_group.location
  resource_group_name = module.resource_group.name
  cluster_name = var.cluster_name
  sku_tier = var.sku_tier
  kubernetes_version = var.kubernetes_version
  system_node_vm_size = var.system_node_vm_size
  user_node_vm_size = var.user_node_vm_size
}