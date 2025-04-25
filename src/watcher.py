from azure.eventhub import EventHubConsumerClient
from azure.identity import DefaultAzureCredential
import json
import logging
import sys

logger = logging.getLogger("azure.eventhub")
logging.basicConfig(level=logging.ERROR)

"""Ejemplo fichero watcher.config.json:
{
    "eventhub-hostname": "<your-eventhub-namespace-name>.servicebus.windows.net",
    "eventhub-name": "<your-eventhub-name>"
}
"""

config_path = sys.argv[1] if len(sys.argv) > 1 else "watcher.config.json"
with open(config_path, "r") as config_file:
    watcher_config = json.load(config_file)

FULLY_QUALIFIED_NAMESPACE = watcher_config["eventhub-hostname"]
EVENTHUB_NAME = watcher_config["eventhub-name"]

def on_event(partition_context, event):
    # Put your code here.
    # If the operation is i/o intensive, multi-thread will have better performance.
    print("Received event from partition: {}.".format(partition_context.partition_id))
    cloud_event = json.JSONDecoder().decode(event.body_as_str(encoding="UTF-8"))
    print("eventType: {}.".format(cloud_event[0]["eventType"]))
    print("operation: {}.".format(cloud_event[0]["data"]["operationName"]))
    print("resource: {}.".format(cloud_event[0]["data"]["resourceUri"]))

def on_partition_initialize(partition_context):
    # Put your code here.
    print("Connection to partition {} has been initialized.".format(partition_context.partition_id))

def on_partition_close(partition_context, reason):
    # Put your code here.
    print("Partition: {} has been closed, reason for closing: {}.".format(partition_context.partition_id, reason))

def on_error(partition_context, error):
    # Put your code here. partition_context can be None in the on_error callback.
    if partition_context:
        print(
            "An exception: {} occurred during receiving from Partition: {}.".format(
                partition_context.partition_id, error
            )
        )
    else:
        print("An exception: {} occurred during the load balance process.".format(error))

if __name__ == "__main__":
    consumer_client = EventHubConsumerClient(
        fully_qualified_namespace=FULLY_QUALIFIED_NAMESPACE,
        eventhub_name=EVENTHUB_NAME,
        credential=DefaultAzureCredential(),
        consumer_group="$Default",
    )

    try:
        with consumer_client:
            consumer_client.receive(
                on_event=on_event,
                on_partition_initialize=on_partition_initialize,
                on_partition_close=on_partition_close,
                on_error=on_error,
                starting_position="@latest",  # "-1" is from the beginning of the partition. @latest to get the newest
            )
    except KeyboardInterrupt:
        consumer_client.close()
        print("Stopped receiving.")