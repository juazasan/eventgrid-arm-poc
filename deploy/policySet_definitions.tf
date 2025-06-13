locals {
  arm_events_policy_set_definition = jsondecode(file("./definitions/policySetDefinitions/arm-events.json"))
}

resource "azurerm_policy_set_definition" "arm_events" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_events_policy_set_definition.name
  policy_type         = "Custom"
  display_name        = local.arm_events_policy_set_definition.properties.displayName
  description         = local.arm_events_policy_set_definition.properties.description
  metadata            = jsonencode(local.arm_events_policy_set_definition.properties.metadata)
  parameters          = jsonencode(local.arm_events_policy_set_definition.properties.parameters)

  dynamic "policy_definition_reference" {
    for_each = local.arm_events_policy_set_definition.properties.policyDefinitions
    content {
      policy_definition_id = "${var.policy_definition_scope_id}/providers/Microsoft.Authorization/policyDefinitions/${policy_definition_reference.value["policyDefinitionId"]}"
      parameter_values     = jsonencode(policy_definition_reference.value["parameters"])
    }
  }

  depends_on = [
    azurerm_policy_definition.arm_subscription_events_system_topic_creation,
    azurerm_policy_definition.arm_resource_group_write_event_subscription,
    azurerm_policy_definition.arm_resource_group_delete_event_subscription,
    azurerm_policy_definition.arm_aks_cluster_write_event_subscription,
    azurerm_policy_definition.arm_aks_cluster_delete_event_subscription,
    azurerm_policy_definition.arm_tags_write_event_subscription
  ]

}