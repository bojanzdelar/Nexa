import boto3
import base64
import logging

logging.basicConfig(level=logging.INFO)

ssm = boto3.client("ssm")


def lambda_handler(event, context):
    try:
        video_id = event["pathParameters"]["video_id"]
        param_name = f"/nexa/hls/{video_id}"

        logging.info(f"Fetching HLS key for video {video_id}")

        response = ssm.get_parameter(Name=param_name, WithDecryption=True)
        key_hex = response["Parameter"]["Value"]

        key_bytes = bytes.fromhex(key_hex)

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/octet-stream",
                "Cache-Control": "no-store"
            },
            "body": base64.b64encode(key_bytes).decode("utf-8"),
            "isBase64Encoded": True
        }

    except ssm.exceptions.ParameterNotFound:
        return {
            "statusCode": 404,
            "body": "Key not found"
        }

    except Exception as e:
        logging.error(f"Key retrieval failed: {e}")
        return {
            "statusCode": 500,
            "body": "Key retrieval failed"
        }
