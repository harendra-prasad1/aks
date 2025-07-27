data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.cluster_name}"

  kubernetes_version            = data.azurerm_kubernetes_service_versions.current.latest_version
  sku_tier                      = var.sku_tier
  private_cluster_enabled       = false

  default_node_pool {
    name                = "systemnp"
    vm_size             = var.system_node_vm_size
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    orchestrator_version = var.data.azurerm_kubernetes_service_versions.current.latest_version
    node_labels         = { "nodepool-type" = "system" }
    #zones               = ["1", "2", "3"] # High availability
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  azure_active_directory_role_based_access_control {
    managed = true
    azure_rbac_enabled = true
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  tags = {
    environment = "production"
  }
}

# User Node Pool - Spot Instances for Cost Optimization
resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = var.user_node_vm_size
  mode                  = "User"

  enable_auto_scaling = true
  min_count             = 1
  max_count             = 5

  node_labels           = { "nodepool-type" = "user" }

  spot_max_price        = -1 # Use -1 for on-demand price cap
  priority              = "Spot"
  eviction_policy       = "Delete"

  #zones                 = ["1", "2", "3"]

  orchestrator_version  = var.data.azurerm_kubernetes_service_versions.current.latest_version

  tags = {
    environment = "production"
  }
}