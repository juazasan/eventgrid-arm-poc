# Overview

ARM Events is an example on how to capture Azure Resource Manager events at scale using Azure Event Grid and Azure Policies.

## Architecture:

- Management Subscription: You need a subscription that will host an Event Hub which will receive selected ARM Events from your Landing Zones subscriptions.
- Application Landing Zone subscriptions: You need to create or identify the Management Group under which the Application Landing Zone subscriptions will land. ARM Events' Azure Policies at applied to that Management Group and will take care of deploying Azure Event Grid components responsible of capturing and sending selected ARM Events to the Event Hub in the Management Subscription.

# How to install the solution

1. Deploy the terraform template from Prerequisites folder to your Management Subscription.
2. Update deploy\definitions\policyAssignments\arm-events.json as per the outputs from step 1.
3. Deploy the terraform templates from Deploy folder to the Landing Zones Management Group.