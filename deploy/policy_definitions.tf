locals {
  arm_subscription_events_system_topic_creation_policy_definition = jsondecode(file("./definitions/policyDefinitions/arm-subscription-events-system-topic-creation.json"))
  arm_resource_group_write_event_subscription_policy_definition = jsondecode(file("./definitions/policyDefinitions/arm-resource-group-write-event-subscription.json"))
  arm_resource_group_delete_event_subscription_policy_definition = jsondecode(file("./definitions/policyDefinitions/arm-resource-group-delete-event-subscription.json"))
  arm_aks_cluster_write_event_subscription_policy_definition = jsondecode(file("./definitions/policyDefinitions/arm-aks-cluster-write-event-subscription.json"))
  arm_aks_cluster_delete_event_subscription_policy_definition = jsondecode(file("./definitions/policyDefinitions/arm-aks-cluster-delete-event-subscription.json"))
  arm_tags_write_event_subscription_policy_definition = jsondecode(file("./definitions/policyDefinitions/arm-tags-write-event-subscription.json"))
}

resource "azurerm_policy_definition" "arm_subscription_events_system_topic_creation" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_subscription_events_system_topic_creation_policy_definition.name
  policy_type         = local.arm_subscription_events_system_topic_creation_policy_definition.properties.policyType
  mode                = local.arm_subscription_events_system_topic_creation_policy_definition.properties.mode
  display_name        = local.arm_subscription_events_system_topic_creation_policy_definition.properties.displayName
  description         = local.arm_subscription_events_system_topic_creation_policy_definition.properties.description
  metadata            = jsonencode(local.arm_subscription_events_system_topic_creation_policy_definition.properties.metadata)
  parameters          = jsonencode(local.arm_subscription_events_system_topic_creation_policy_definition.properties.parameters)
  policy_rule         = jsonencode(local.arm_subscription_events_system_topic_creation_policy_definition.properties.policyRule)
}

resource "azurerm_policy_definition" "arm_resource_group_write_event_subscription" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_resource_group_write_event_subscription_policy_definition.name
  policy_type         = local.arm_resource_group_write_event_subscription_policy_definition.properties.policyType
  mode                = local.arm_resource_group_write_event_subscription_policy_definition.properties.mode
  display_name        = local.arm_resource_group_write_event_subscription_policy_definition.properties.displayName
  description         = local.arm_resource_group_write_event_subscription_policy_definition.properties.description
  metadata            = jsonencode(local.arm_resource_group_write_event_subscription_policy_definition.properties.metadata)
  parameters          = jsonencode(local.arm_resource_group_write_event_subscription_policy_definition.properties.parameters)
  policy_rule         = jsonencode(local.arm_resource_group_write_event_subscription_policy_definition.properties.policyRule)
}

resource "azurerm_policy_definition" "arm_resource_group_delete_event_subscription" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_resource_group_delete_event_subscription_policy_definition.name
  policy_type         = local.arm_resource_group_delete_event_subscription_policy_definition.properties.policyType
  mode                = local.arm_resource_group_delete_event_subscription_policy_definition.properties.mode
  display_name        = local.arm_resource_group_delete_event_subscription_policy_definition.properties.displayName
  description         = local.arm_resource_group_delete_event_subscription_policy_definition.properties.description
  metadata            = jsonencode(local.arm_resource_group_delete_event_subscription_policy_definition.properties.metadata)
  parameters          = jsonencode(local.arm_resource_group_delete_event_subscription_policy_definition.properties.parameters)
  policy_rule         = jsonencode(local.arm_resource_group_delete_event_subscription_policy_definition.properties.policyRule)
}

resource "azurerm_policy_definition" "arm_aks_cluster_write_event_subscription" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_aks_cluster_write_event_subscription_policy_definition.name
  policy_type         = local.arm_aks_cluster_write_event_subscription_policy_definition.properties.policyType
  mode                = local.arm_aks_cluster_write_event_subscription_policy_definition.properties.mode
  display_name        = local.arm_aks_cluster_write_event_subscription_policy_definition.properties.displayName
  description         = local.arm_aks_cluster_write_event_subscription_policy_definition.properties.description
  metadata            = jsonencode(local.arm_aks_cluster_write_event_subscription_policy_definition.properties.metadata)
  parameters          = jsonencode(local.arm_aks_cluster_write_event_subscription_policy_definition.properties.parameters)
  policy_rule         = jsonencode(local.arm_aks_cluster_write_event_subscription_policy_definition.properties.policyRule)
}

resource "azurerm_policy_definition" "arm_aks_cluster_delete_event_subscription" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_aks_cluster_delete_event_subscription_policy_definition.name
  policy_type         = local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.policyType
  mode                = local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.mode
  display_name        = local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.displayName
  description         = local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.description
  metadata            = jsonencode(local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.metadata)
  parameters          = jsonencode(local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.parameters)
  policy_rule         = jsonencode(local.arm_aks_cluster_delete_event_subscription_policy_definition.properties.policyRule)
}

resource "azurerm_policy_definition" "arm_tags_write_event_subscription" {
  management_group_id = var.policy_definition_scope_id
  name                = local.arm_tags_write_event_subscription_policy_definition.name
  policy_type         = local.arm_tags_write_event_subscription_policy_definition.properties.policyType
  mode                = local.arm_tags_write_event_subscription_policy_definition.properties.mode
  display_name        = local.arm_tags_write_event_subscription_policy_definition.properties.displayName
  description         = local.arm_tags_write_event_subscription_policy_definition.properties.description
  metadata            = jsonencode(local.arm_tags_write_event_subscription_policy_definition.properties.metadata)
  parameters          = jsonencode(local.arm_tags_write_event_subscription_policy_definition.properties.parameters)
  policy_rule         = jsonencode(local.arm_tags_write_event_subscription_policy_definition.properties.policyRule)
}