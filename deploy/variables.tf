# subscription id
variable "subscription_id" {
  description = "The Id of Your default Azure Subscription"
  type        = string
}

# Policy Definition Publishing Scope
variable "policy_definition_scope_id" {
  description = "The Id of the management group to which the policy definitions will be published."
  type        = string
  default     = "00000000-0000-0000-0000-000000000000" # Replace with your management group ID
}

