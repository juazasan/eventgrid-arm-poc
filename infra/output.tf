output "event-hub-hostname" {
  value = "${azurerm_eventhub_namespace.eventhub_ns.name}.servicebus.windows.net"
}

output "event-hub-name" {
  value = azurerm_eventhub.eventhub.name
}