output "event-hub-hostname" {
  value = "${azurerm_eventhub_namespace.eventhub_ns.name}.servicebus.windows.net"
}

output "event-hub-name" {
  value = azurerm_eventhub.eventhub.name
}

output "armEventsLogAnalyticsWorkspaceId" {
  value = azurerm_log_analytics_workspace.law.id
}

output "armEventsEventHubId" {
  value = azurerm_eventhub.eventhub.id
}

output "armEventsEventHubNamespaceId" {
  value = azurerm_eventhub_namespace.eventhub_ns.id
}

output "armEventsSystemTopicUserAssignedIdentityId" {
  value = azurerm_user_assigned_identity.mi_eventgrid_system_topic.id
}

