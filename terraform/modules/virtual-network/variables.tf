variable "resource_group_name" {}
variable "location" {}
variable "vnet_name" {}
variable "address_space" {
  type = list(string)
}
