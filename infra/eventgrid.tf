# monitoring resources

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${azurerm_resource_group.rg.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Capture ARM events from target subscription

resource "azurerm_eventgrid_system_topic" "topic_arm" {
  name                   = "eventgrid-arm-poc-resources-topic"
  location               = "Global"
  resource_group_name    = azurerm_resource_group.rg.name
  source_arm_resource_id = "/subscriptions/${var.subscription_id}"
  topic_type             = "Microsoft.Resources.Subscriptions"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                       = "diagnostic-setting-${azurerm_eventgrid_system_topic.topic_arm.name}"
  target_resource_id         = azurerm_eventgrid_system_topic.topic_arm.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "DeliveryFailures"
  }

}

# subscribe to resource group write events
# tests:
# az group create -n eventgrid-arm-poc-test -l spaincentral
resource "azurerm_eventgrid_system_topic_event_subscription" "rg_write_events_subscription" {
  name                 = "resource-group-write-events-subscription"
  system_topic         = azurerm_eventgrid_system_topic.topic_arm.name
  resource_group_name  = azurerm_resource_group.rg.name
  eventhub_endpoint_id = azurerm_eventhub.eventhub.id
  included_event_types = [
    "Microsoft.Resources.ResourceWriteSuccess"
  ]
  advanced_filter {
    string_begins_with {
      key    = "data.operationName"
      values = ["Microsoft.Resources/subscriptions/resourceGroups/write"]
    }
  }

  delivery_identity {
    type                   = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.eventhub_send_role
  ]

}

# subscribe to resource group delete events
# tests:
# az group delete -n eventgrid-arm-poc-test --yes --no-wait
resource "azurerm_eventgrid_system_topic_event_subscription" "rg_delete_events_subscription" {
  name                 = "resource-group-delete-events-subscription"
  system_topic         = azurerm_eventgrid_system_topic.topic_arm.name
  resource_group_name  = azurerm_resource_group.rg.name
  eventhub_endpoint_id = azurerm_eventhub.eventhub.id
  included_event_types = [
    "Microsoft.Resources.ResourceDeleteSuccess"
  ]
  advanced_filter {
    string_begins_with {
      key    = "data.operationName"
      values = ["Microsoft.Resources/subscriptions/resourceGroups/delete"]
    }
  }

  delivery_identity {
    type                   = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.eventhub_send_role
  ]

}

# subscribe to tag write events
# tests:
# az storage account create -n b3f13ff2 -g eventgrid-arm-poc-test --sku Standard_LRS --kind StorageV2 --location spaincentral
# $resource=az resource show -g eventgrid-arm-poc-test -n b3f13ff2 --resource-type Microsoft.Storage/storageAccounts --query "id" --output tsv
# az tag create --resource-id $resource --tags Dept=Finance
# az tag update --operation Merge --tags Dept=Finance CostCenter=CCFinance --resource-id $resource
resource "azurerm_eventgrid_system_topic_event_subscription" "tag_write_events_subscription" {
  name                 = "tag-write-events-subscription"
  system_topic         = azurerm_eventgrid_system_topic.topic_arm.name
  resource_group_name  = azurerm_resource_group.rg.name
  eventhub_endpoint_id = azurerm_eventhub.eventhub.id
  included_event_types = [
    "Microsoft.Resources.ResourceWriteSuccess"
  ]
  advanced_filter {
    string_begins_with {
      key    = "data.operationName"
      values = ["Microsoft.Resources/tags/write"]
    }
  }

  delivery_identity {
    type                   = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.eventhub_send_role
  ]

}

# subscribe to cluster write events
# tests:
# az aks create -g eventgrid-arm-poc-test -n eventgrid-arm-poc-test --node-count 1 --location spaincentral
resource "azurerm_eventgrid_system_topic_event_subscription" "aks_write_events_subscription" {
  name                 = "aks-write-events-subscription"
  system_topic         = azurerm_eventgrid_system_topic.topic_arm.name
  resource_group_name  = azurerm_resource_group.rg.name
  eventhub_endpoint_id = azurerm_eventhub.eventhub.id
  included_event_types = [
    "Microsoft.Resources.ResourceWriteSuccess"
  ]
  advanced_filter {
    string_begins_with {
      key    = "data.operationName"
      values = ["Microsoft.ContainerService/managedClusters/write"]
    }
  }

  delivery_identity {
    type                   = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.eventhub_send_role
  ]

}

# subscribe to cluster delete events
# tests:
# az aks delete -g eventgrid-arm-poc-test -n eventgrid-arm-poc-test --yes --no-wait
resource "azurerm_eventgrid_system_topic_event_subscription" "aks_delete_events_subscription" {
  name                 = "aks-delete-events-subscription"
  system_topic         = azurerm_eventgrid_system_topic.topic_arm.name
  resource_group_name  = azurerm_resource_group.rg.name
  eventhub_endpoint_id = azurerm_eventhub.eventhub.id
  included_event_types = [
    "Microsoft.Resources.ResourceDeleteSuccess"
  ]
  advanced_filter {
    string_begins_with {
      key    = "data.operationName"
      values = ["Microsoft.ContainerService/managedClusters/delete"]
    }
  }

  delivery_identity {
    type                   = "SystemAssigned"
  }

  depends_on = [
    azurerm_role_assignment.eventhub_send_role
  ]

}
