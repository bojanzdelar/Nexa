import time
import json
import base64
import rsa


def _b64(x: bytes) -> str:
    return (
        base64.b64encode(x)
        .decode()
        .replace("+", "-")
        .replace("=", "_")
        .replace("/", "~")
    )


def generate_cf_cookies(domain: str, content_path: str, private_key, public_key_id: str, ttl):
    expire_time = int(time.time()) + ttl

    policy = {
        "Statement": [
            {
                "Resource": f"{domain}/*{content_path}/*",
                "Condition": {
                    "DateLessThan": {"AWS:EpochTime": expire_time}
                },
            }
        ]
    }

    policy_json = json.dumps(policy).encode()
    signature = rsa.sign(policy_json, private_key, "SHA-1")

    return {
        "CloudFront-Policy": _b64(policy_json),
        "CloudFront-Signature": _b64(signature),
        "CloudFront-Key-Pair-Id": public_key_id,
    }
