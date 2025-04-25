# subscription id
variable "subscription_id" {
  description = "The subscription ID to use for the Azure provider."
  type        = string
}

# resource group name

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resource."
  type        = string
}

# location

variable "location" {
  description = "The Azure region in which to create the resource."
  type        = string
  default     = "Germany West Central"
}
