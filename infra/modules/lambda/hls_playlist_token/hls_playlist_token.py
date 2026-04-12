import boto3
import json
import time
import os
from jose import jwt
from auth.cognito import verify_token

ssm = boto3.client("ssm")

param_secret = ssm.get_parameter(
    Name=os.environ["SIGNING_SECRET_NAME"],
    WithDecryption=True
)
SECRET = param_secret["Parameter"]["Value"].encode()
USER_POOL_ISSUER = os.environ["USER_POOL_ISSUER"]

PLAYLIST_TOKEN_TTL_SECONDS = 10800  # 3 hours


def lambda_handler(event, context):
    headers = event.get("headers") or {}
    auth = headers.get("authorization") or headers.get("Authorization") or ""

    try:
        _ = verify_token(auth, USER_POOL_ISSUER)
    except Exception:
        return {"statusCode": 401, "body": "Unauthorized"}

    path_params = event.get("pathParameters") or {}
    proxy = path_params.get("proxy")

    if not proxy:
        return {"statusCode": 400, "body": "Invalid path"}

    path = f"/playlists/{proxy}"

    payload = {
        "path": path,
        "exp": int(time.time()) + PLAYLIST_TOKEN_TTL_SECONDS
    }
    playlist_token = jwt.encode(payload, SECRET, algorithm="HS256")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"token": playlist_token})
    }
