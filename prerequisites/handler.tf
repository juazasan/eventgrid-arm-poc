# add storage account for blob storage, with access only from Azure Trusted Services

resource "random_id" "appId" {
  byte_length = 4
}

data "http" "local_ip" {
  url = "http://api.ipify.org?format=json"
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "storage" {
  name                     = "${substr(md5(azurerm_resource_group.rg.name), 0, 8)}${random_id.appId.dec}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = ["${jsondecode(data.http.local_ip.response_body).ip}"]
  }
}

# add event hub to host event grid system events

resource "azurerm_eventhub_namespace" "eventhub_ns" {
  name                          = "ehns-${substr(azurerm_resource_group.rg.name, 0, 9)}-${random_id.appId.dec}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  sku                           = "Standard"
  capacity                      = 1
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  network_rulesets {
    public_network_access_enabled  = true
    trusted_service_access_enabled = true
    default_action                 = "Allow"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_eventhub" "eventhub" {
  name              = "eh-${azurerm_resource_group.rg.name}"
  namespace_id      = azurerm_eventhub_namespace.eventhub_ns.id
  partition_count   = 1
  message_retention = 1
  capture_description {
    enabled = true
    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = "arm"
      storage_account_id  = azurerm_storage_account.storage.id
    }
    encoding = "Avro"
  }
}

resource "azurerm_user_assigned_identity" "mi_eventgrid_system_topic" {
  name                = "mi-${azurerm_eventhub.eventhub.name}-sender"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "eventhub_send_role" {
  principal_id         = azurerm_user_assigned_identity.mi_eventgrid_system_topic.principal_id
  role_definition_name = "Azure Event Hubs Data Sender"
  scope                = azurerm_eventhub.eventhub.id
}

resource "azurerm_role_assignment" "eventhub_receive_role" {
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Azure Event Hubs Data Receiver"
  scope                = azurerm_eventhub_namespace.eventhub_ns.id
}

# monitoring resources

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${azurerm_resource_group.rg.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}