locals {
  arm_events_policy_assignment = jsondecode(file("./definitions/policyAssignments/arm-events.json"))
}

resource "azurerm_management_group_policy_assignment" "arm_events" {
  name                 = local.arm_events_policy_assignment.assignment.name
  display_name         = local.arm_events_policy_assignment.assignment.displayName
  description          = local.arm_events_policy_assignment.assignment.description
  management_group_id  = local.arm_events_policy_assignment.managementGroupId
  policy_definition_id = "${var.policy_definition_scope_id}/providers/Microsoft.Authorization/policySetDefinitions/${local.arm_events_policy_assignment.definitionEntry.policySetName}"
  parameters           = jsonencode(local.arm_events_policy_assignment.parameters)
  identity {
    type = "SystemAssigned"
  }
  location = local.arm_events_policy_assignment.assignment.location

  depends_on = [azurerm_policy_set_definition.arm_events]
}

resource "azurerm_role_assignment" "arm_events" {
  scope              = local.arm_events_policy_assignment.managementGroupId
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
  principal_id       = azurerm_management_group_policy_assignment.arm_events.identity[0].principal_id

}