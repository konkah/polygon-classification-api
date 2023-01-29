import time
import boto3


async def save_log(message, log_stream):
    logs = boto3.client("logs")
    log_group = "triangle-classification-api-logs"

    timestamp = int(round(time.time() * 1000))

    logs.put_log_events(
        logGroupName = log_group,
        logStreamName = log_stream,
        logEvents = [
            {
                "timestamp":timestamp,
                "message":str(message),
            }
        ]
    )
