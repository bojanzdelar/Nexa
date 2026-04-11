import json
import os
import boto3
import pycountry
import rsa
import requests
from botocore.signers import CloudFrontSigner
from datetime import datetime, timedelta
from jose import jwt

s3 = boto3.client("s3")
ssm = boto3.client("ssm")


BUCKET = os.environ["SUBTITLES_BUCKET"]
PLACEHOLDER_PATH = "placeholders/video-default"
CLOUDFRONT_URL = os.environ["CLOUDFRONT_URL"]
PUBLIC_KEY_ID = os.environ["PUBLIC_KEY_ID"]
PRIVATE_KEY_NAME = os.environ["PRIVATE_KEY_NAME"]
USER_POOL_ISSUER = os.environ["USER_POOL_ISSUER"]
SIGNED_URL_TTL = 300

JWKS_URL = f"{USER_POOL_ISSUER}/.well-known/jwks.json"
JWKS = requests.get(JWKS_URL).json()

param = ssm.get_parameter(
    Name=PRIVATE_KEY_NAME,
    WithDecryption=True
)
PRIVATE_KEY_PEM = param["Parameter"]["Value"].encode()
PRIVATE_KEY = rsa.PrivateKey.load_pkcs1(PRIVATE_KEY_PEM)


def verify_token(auth_header: str):
    if not auth_header or not auth_header.startswith("Bearer "):
        raise Exception("Missing token")

    token = auth_header.split(" ")[1]

    headers = jwt.get_unverified_header(token)
    kid = headers["kid"]

    key = next(k for k in JWKS["keys"] if k["kid"] == kid)

    payload = jwt.decode(
        token,
        key,
        algorithms=["RS256"],
        issuer=USER_POOL_ISSUER,
        options={
            "verify_aud": False,
        },
    )

    if payload.get("token_use") != "access":
        raise Exception("Not an access token")

    return payload


def rsa_signer(message: bytes) -> bytes:
    return rsa.sign(message, PRIVATE_KEY, "SHA-1")


def sign_subtitle(key: str) -> str:
    signer = CloudFrontSigner(PUBLIC_KEY_ID, rsa_signer)

    expires_at = datetime.now() + timedelta(seconds=SIGNED_URL_TTL)

    url = f"{CLOUDFRONT_URL}/{key}"

    return signer.generate_presigned_url(
        url,
        date_less_than=expires_at,
    )


def handle_sign_request(event):
    qs = event.get("queryStringParameters") or {}
    key = qs.get("key")
    url = sign_subtitle(f"subtitles/{key}")

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Cache-Control": "no-store",
        },
        "body": json.dumps({"url": url}),
    }


def list_subtitles(path: str):
    resp = s3.list_objects_v2(Bucket=BUCKET, Prefix=path)

    subtitles = []

    for obj in resp.get("Contents", []):
        key = obj["Key"]

        if not key.endswith(".vtt"):
            continue

        code = key.split("/")[-1].replace(".vtt", "")
        label = code.upper()

        lang = pycountry.languages.get(alpha_2=code)
        if lang:
            label = lang.name

        subtitles.append({
            "code": code,
            "label": label,
            "key": key.removeprefix("subtitles/")
        })

    return subtitles


def lambda_handler(event, context):
    try:
        auth_header = event.get("headers", {}).get("authorization")
        _ = verify_token(auth_header)
    except Exception as e:
        return {
            "statusCode": 401,
            "body": json.dumps({"message": "Unauthorized"}),
        }

    raw_path = event.get("rawPath", "")

    if raw_path == "/subtitles/sign":
        return handle_sign_request(event)

    path = event.get("pathParameters") or {}
    content_type = path.get("type")
    content_id = path.get("id")
    qs = event.get("queryStringParameters") or {}

    if content_type == "movies":
        content_path = f"subtitles/movies/{content_id}/"

    elif content_type == "shows":
        s = int(qs["s"])
        e = int(qs["e"])
        content_path = f"subtitles/shows/{content_id}/s{s:02d}/e{e:02d}/"

    else:
        return {
            "statusCode": 400,
            "body": "Invalid subtitle type",
        }

    subtitles = (
        list_subtitles(content_path)
        or list_subtitles(f"subtitles/{PLACEHOLDER_PATH}/")
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Cache-Control": "private, max-age=300",
        },
        "body": json.dumps(subtitles),
    }
