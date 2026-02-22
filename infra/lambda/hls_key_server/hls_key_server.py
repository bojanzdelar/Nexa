import boto3
import os
import base64
import logging
import time
import hmac
import hashlib

logging.basicConfig(level=logging.INFO)

ssm = boto3.client("ssm")
SECRET = os.environ["SIGNING_SECRET"].encode()


def validate_signed_url(content_type, content_id, exp, sig):
    if not content_type or not content_id or not exp or not sig:
        return False

    if time.time() > int(exp):
        return False

    payload = f"{content_type}:{content_id}:{exp}"

    expected = hmac.new(
        SECRET,
        payload.encode(),
        hashlib.sha256
    ).hexdigest()

    return hmac.compare_digest(expected, sig)


def lambda_handler(event, context):
    try:
        path = event.get("pathParameters") or {}
        qs = event.get("queryStringParameters") or {}

        content_type = path.get("type")
        content_id = path.get("id")

        exp = qs.get("exp")
        sig = qs.get("sig")

        if not validate_signed_url(content_type, content_id, exp, sig):
            return {"statusCode": 401}

        param_name = f"/nexa/hls/{content_type}/{content_id}"
        logging.info(f"Fetching HLS key for {content_type}/{content_id}")

        response = ssm.get_parameter(
            Name=param_name,
            WithDecryption=True
        )

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
