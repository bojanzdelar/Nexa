from auth.signing import validate_signed_url
import boto3
import os
import base64

ssm = boto3.client("ssm")
param = ssm.get_parameter(
    Name=os.environ["SIGNING_SECRET_NAME"],
    WithDecryption=True
)
SECRET = param["Parameter"]["Value"].encode()


def parse_scope(proxy: str) -> str:
    parts = proxy.split("/")

    if parts[0] == "shows":
        return "/".join(parts[:4])

    return "/".join(parts[:2])


def lambda_handler(event, context):
    try:
        proxy = event.get("pathParameters", {}).get("proxy", "")
        qs = event.get("queryStringParameters") or {}

        scope = parse_scope(proxy)

        exp = qs.get("exp")
        sig = qs.get("sig")

        if not validate_signed_url(scope, exp, sig, SECRET):
            return {"statusCode": 401}

        param_name = f"/nexa/hls/{scope}"

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

    except ValueError:
        return {"statusCode": 404}

    except ssm.exceptions.ParameterNotFound:
        return {"statusCode": 404}

    except Exception as e:
        return {"statusCode": 500}
