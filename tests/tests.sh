#!/bin/bash
# tests.sh - Bash script for running tests in the eventgrid-arm-poc project

echo "Running tests..."

# Check Resource Group Write Event
az group create -n eventgrid-arm-poc-test -l spaincentral

# Check Tags Write Event
az storage account create -n b3f13ff2 -g eventgrid-arm-poc-test --sku Standard_LRS --kind StorageV2 --location spaincentral
resource=$(az resource show -g eventgrid-arm-poc-test -n b3f13ff2 --resource-type Microsoft.Storage/storageAccounts --query "id" --output tsv)
az tag create --resource-id $resource --tags Dept=Finance
az tag update --operation Merge --tags Dept=Finance CostCenter=CCFinance --resource-id $resource

# Check AKS Cluster Write Event
az aks create -g eventgrid-arm-poc-test -n eventgrid-arm-poc-test --node-count 1 --location spaincentral

# Check AKS Cluster Delete Event
az aks delete -g eventgrid-arm-poc-test -n eventgrid-arm-poc-test --yes

#Check Resource Group Delete Event
az group delete -n eventgrid-arm-poc-test --yes

echo "All tests completed."